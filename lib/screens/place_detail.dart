import 'dart:io';

import 'package:f07_recursos_nativos/models/place.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../components/image_input.dart';
import '../components/location_input.dart';
import '../provider/great_places.dart';

class PlaceDetail extends StatefulWidget {
  _PlaceDetailState createState() => _PlaceDetailState();
}

class _PlaceDetailState extends State<PlaceDetail> {
  final _titleController = TextEditingController();

  //deve receber a imagem
  File? _pickedImage;

  void _selectImage(File? pickedImage) {
    _pickedImage = pickedImage;
  }

  //

  void _editPlace(String id) {
    if (_titleController.text.isEmpty || _pickedImage == null) {
      return;
    }
    // Provider.of<GreatPlaces>(context, listen: false)
    //     .editPlace(_titleController.text, _pickedImage!,  id);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final place = ModalRoute.of(context)!.settings.arguments as Place;
    _titleController.text = place.title;

    _pickedImage = File('${place.image}');

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do ${place.title}'),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(place.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          )),
                      SizedBox(height: 30),
                      SizedBox(
                          width: 400,
                          height: 300,
                          child: Card(
                            child: Image.file(place.image, fit: BoxFit.cover),
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: ElevatedButton.icon(
                            label: Text('Editar lugar'),
                            icon: Icon(Icons.edit),
                            onPressed: () => {},
                          ))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: OutlinedButton.icon(
                                  onPressed: () => {},
                                  icon: Icon(Icons.delete, color: Colors.red,),
                                  style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.red)),
                                  label: Text('Excluir lugar', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),)))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
