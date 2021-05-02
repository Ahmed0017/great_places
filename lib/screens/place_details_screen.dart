import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/place.dart';
import './map_screen.dart';
import '../providers/great_places.dart';

class PlaceDetailsScreen extends StatelessWidget {
  static const routeName = '/place-details';
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final Place place =
        Provider.of<GreatPlaces>(context, listen: false).findById(id);

    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            child: Image.file(
              place.imageFile,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            place.location.address,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (ctx) => MapScreen(
                    initialLocation: place.location,
                  ),
                ),
              );
            },
            child: Text('View on Map'),
          ),
        ],
      ),
    );
  }
}
