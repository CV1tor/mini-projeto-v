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
    }
    // else {
    //   print("\n MOSTRANDO FIREBASE... \n");
    //   final future = http.get(Uri.parse("$_url/places.json"), 
    //   headers: <String, String> {
    //     'Content-type'
    //   });


    // }

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

  void addPlace(
    String title,
    File image,
  ) async {
    bool conectadoInternet = await InternetConnectionChecker().hasConnection;
    final newPlace = Place(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
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
    }
    else {
      print("SEM CONEXÃO COM A INTERNET! \n");
    }

    DbUtil.insert('places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path
    });

    _items.add(newPlace);
    notifyListeners();
  }

  void removePlace(String id) {
    _items.removeWhere((element) => element.id == id);

    DbUtil.delete('places', id);

    notifyListeners();
  }
}