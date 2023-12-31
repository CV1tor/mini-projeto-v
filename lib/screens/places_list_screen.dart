import 'dart:io';

import 'package:f07_recursos_nativos/models/place.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/great_places.dart';
import '../utils/app_routes.dart';

class PlacesListScreen extends StatelessWidget {

  _placeDetails(BuildContext context, Place place) {
    Navigator.of(context).pushNamed(AppRoutes.PLACE_DETAIL, arguments: place);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Lugares'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PLACE_FORM);
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body:
          FutureBuilder(
            future: Provider.of<GreatPlaces>(context, listen: false).loadPlaces(),
            builder: (ctx, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : Consumer<GreatPlaces>(
                    child: Center(
                      child: Text('Nenhum local'),
                    ),
                    builder: (context, greatPlaces, child) =>
                        greatPlaces.itemsCount == 0
                            ? child!
                            : ListView.builder(
                                itemCount: greatPlaces.itemsCount,
                                itemBuilder: (context, index) => ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: FileImage(
                                        greatPlaces.itemByIndex(index).image),
                                  ),
                                  title: Text(greatPlaces.itemByIndex(index).title),
                                  onTap: () => _placeDetails(context, greatPlaces.itemByIndex(index)),
                                ),
                              ),
                  ),
          ),
      
      floatingActionButton: FloatingActionButton(onPressed: () => Provider.of<GreatPlaces>(context, listen: false).syncData(), child: Icon(Icons.sync),),
    );
  }
}
