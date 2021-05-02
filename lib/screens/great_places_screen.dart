import 'package:flutter/material.dart';
import 'package:great_places/widgets/places_list.dart';
import 'package:provider/provider.dart';

import './add_place_screen.dart';
import '../providers/great_places.dart';

class GreatPlacesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Great Places'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );

          return PlacesList();
        },
      ),
    );
  }
}
