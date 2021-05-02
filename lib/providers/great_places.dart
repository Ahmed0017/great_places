import 'dart:io';

import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';

import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> fetchAndSetPlaces() async {
    final data = await DBHelper.fetchData('places');
    List<Place> loadedData = [];

    loadedData = data.map((place) {
      return Place(
        id: place['id'],
        title: place['title'],
        imageFile: File(place['image']),
        location: PlaceLocation(
          latitude: place['loc_lat'],
          longitude: place['loc_lng'],
          address: place['address'],
        ),
      );
    }).toList();

    _items = loadedData;
    notifyListeners();
  }

  void addPlace(String title, File image, PlaceLocation locationData) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      imageFile: image,
      location: locationData,
    );

    _items.insert(0, newPlace);

    DBHelper.insert('places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.imageFile.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'address': newPlace.location.address
    });

    notifyListeners();
  }

  Place findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }
}
