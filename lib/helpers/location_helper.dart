import 'dart:convert';

import 'package:http/http.dart' as http;

// Add GOOGLE_API_KEY

class LocationHelper {
  static String generateLocationPreviewImageUrl({
    double latitude,
    double longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=GOOGLE_API_KEY';
  }

  static Future<String> getLocationAddress(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=GOOGLE_API_KEY');
    final response = await http.get(url);

    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
