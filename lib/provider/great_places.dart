import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../models/place.dart';
import '../utils/db_util.dart';
import 'package:http/http.dart' as http;

class GreatPlaces with ChangeNotifier {
  final _url = "https://mini-projeto-v-default-rtdb.firebaseio.com/";

  List<Place> _items = [];

  Future<void> loadPlaces() async {
    bool conectadoInternet = await InternetConnectionChecker().hasConnection;

    if (!conectadoInternet) {
      print("\n\nMOSTRANDO SQLITE...\n\n");
      final dataList = await DbUtil.getData('places');
      _items = dataList
          .map(
            (item) => Place(
              id: item['id'],
              title: item['title'],
              image: File(item['image']),
              location: PlaceLocation(
                latitude: 0.0,
                longitude: 0.0,
              ),
            ),
          )
          .toList();
    } else {
      print("\n MOSTRANDO FIREBASE... \n");
      final response = await http.get(Uri.parse("$_url/places.json"));
      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);

        body.values.forEach((element) {
          Place newPlace = Place.fromJson(element);

          _items.add(newPlace);
        });
      } else {
        throw Exception('[ERRO] Não foi possível carregar items do firebase');
      }
    }

    _items.sort(((a, b) => int.parse(b.id).compareTo(int.parse(a.id))));

    notifyListeners();
  }

  List<Place> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Place itemByIndex(int index) {
    return _items[index];
  }

  void addPlace(String title, File image, String id) async {
    bool conectadoInternet = await InternetConnectionChecker().hasConnection;
    final newPlace = Place(
        id: id.isNotEmpty
            ? id
            : DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        location: null,
        image: image);

    if (conectadoInternet) {
      print("CONECTADO A INTERNET! SALVANDO NO FIREBASE... \n");
      final future = await http.post(Uri.parse('$_url/places.json'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "id": newPlace.id,
            "title": newPlace.title,
            "location": newPlace.location,
            "image": newPlace.image.path
          }));

      if (future.statusCode != 200) {
        throw Exception("[ERRO] Não foi possível adicionar o lugar! \n");
      }
    } else {
      print("SEM CONEXÃO COM A INTERNET! \n");
    }

    await DbUtil.insert('places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path
    });

    final dataList = await DbUtil.getData('places');

    // Salvar apenas os 5 ultimos lugares
    if (dataList.length > 5) {
      print(
          "\n BANCO LOCAL COM MAIS DE 5 REGISTROS! DELETANDO MAIS ANTIGO... ");

      await DbUtil.delete('table', dataList[0]['id']);
    }

    _items.add(newPlace);
    _items.sort(((a, b) => int.parse(b.id).compareTo(int.parse(a.id))));
    notifyListeners();
  }

  void removePlace(String id) async {
    _items.removeWhere((element) => element.id == id);

    await DbUtil.delete('places', id);

    notifyListeners();
  }

  syncData() async {
    bool conectadoInternet = await InternetConnectionChecker().hasConnection;

    if (conectadoInternet) {
      final dataList = await DbUtil.getData('places');

      for (var i = dataList.length - 1; i > 0; i--) {
        print('\n $i \n');
        bool contains =
            items.any((element) => element.id == dataList[i].values.first);

        if (contains) {
          print("\n Tem o valor ${dataList[i].values} \n");
        } else {
          print("\n Adicionando ${dataList[i].values}... \n");

          addPlace(dataList[i]['title'], File(dataList[i]['image']),
              dataList[i]['id']);

          notifyListeners();
        }
      }
    } else {
      throw Exception('[ERRO] Para sincronizar é necessário estar conectado!');
    }

    return;
  }

  void editPlace(String tite, File image, String id) {}
}
