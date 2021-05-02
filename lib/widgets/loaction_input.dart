import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/location_helper.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function getLocationData;

  LocationInput(this.getLocationData);
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  void _showPreviewImage(double lat, double lng) {
    setState(() {
      _previewImageUrl = LocationHelper.generateLocationPreviewImageUrl(
        latitude: lat,
        longitude: lng,
      );
    });
  }

  Future<void> _getCurrenLocation() async {
    try {
      final locData = await Location().getLocation();

      _showPreviewImage(
        locData.latitude,
        locData.longitude,
      );
      widget.getLocationData(
        locData.latitude,
        locData.longitude,
      );
    } catch (err) {
      print('ERRORRRR $err');
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );

    if (selectedLocation == null) return;

    _showPreviewImage(
      selectedLocation.latitude,
      selectedLocation.longitude,
    );

    widget.getLocationData(
      latitude: selectedLocation.latitude,
      longitude: selectedLocation.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          child: _previewImageUrl == null
              ? Text(
                  'No location added',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: Icon(Icons.location_on),
              label: Text('Current location'),
              onPressed: _getCurrenLocation,
            ),
            TextButton.icon(
              icon: Icon(Icons.map),
              label: Text('Select on Map'),
              onPressed: _selectOnMap,
            ),
          ],
        ),
      ],
    );
  }
}
