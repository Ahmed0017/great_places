import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/great_places.dart';
import '../screens/place_details_screen.dart';

class PlacesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final places = Provider.of<GreatPlaces>(context);
    return places.items.length <= 0
        ? Center(
            child: Text('Got no Places yet! Start add some.'),
          )
        : ListView.builder(
            itemCount: places.items.length,
            itemBuilder: (ctx, i) => ListTile(
              leading: CircleAvatar(
                backgroundImage: FileImage(places.items[i].imageFile),
              ),
              title: Text(places.items[i].title),
              subtitle: Text(places.items[i].location.address),
              onTap: () => Navigator.of(context).pushNamed(
                PlaceDetailsScreen.routeName,
                arguments: places.items[i].id,
              ),
            ),
          );
  }
}
