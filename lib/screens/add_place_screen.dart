import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/image_input.dart';
import '../widgets/loaction_input.dart';
import '../providers/great_places.dart';
import '../models/place.dart';
import '../helpers/location_helper.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';
  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File _pickedImage;
  PlaceLocation _locationData;

  void _selectImage(File image) {
    _pickedImage = image;
  }

  Future<void> _getLocationData(double lat, double lng) async {
    final address = await LocationHelper.getLocationAddress(
      lat,
      lng,
    );
    _locationData = PlaceLocation(
      latitude: lat,
      longitude: lng,
      address: address,
    );
  }

  void savePlace() {
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _locationData == null) {
      return;
    }
    Provider.of<GreatPlaces>(context, listen: false).addPlace(
      _titleController.text,
      _pickedImage,
      _locationData,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Place'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      controller: _titleController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ImageInput(_selectImage),
                    SizedBox(
                      height: 10,
                    ),
                    LocationInput(_getLocationData)
                  ],
                ),
              ),
              padding: EdgeInsets.all(10),
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add Place'),
            onPressed: savePlace,
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).accentColor,
              onPrimary: Colors.black,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
