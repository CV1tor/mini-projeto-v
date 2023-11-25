import 'dart:io';

import 'package:f07_recursos_nativos/models/place.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../components/image_input.dart';
import '../components/location_input.dart';
import '../provider/great_places.dart';

class PlaceDetail extends StatefulWidget{
  
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
        title: Text('Editar Lugar'),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Título',
                      ),
                    ),
                    SizedBox(height: 10),
                    ImageInput(this._selectImage),
                    SizedBox(height: 10),
                    LocationInput(),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Salvar'),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.secondary,
              onPrimary: Colors.black,
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () => _editPlace(place.id),
          ),
        ],
      ),
    );
  }
}


