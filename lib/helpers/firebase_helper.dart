import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/monument.dart';

class FirebaseHelper {
  // Insert your firebase-URL here ...
  static final url = Uri.https(
      'https://spl-flutter-default-rtdb.europe-west1.firebasedatabase.app/',
      '/locations.json');

  static Future<void> addLocation(Monument location) async {
    
    try {
      final response = await http.post(url,
        body: json.encode({
          'date': location.date,
          'title': location.title,
          'description': location.description,
          'lat': location.lat,
          'long': location.long,
          'filelink': location.fileLink,
        }));

      return json.decode(response.body)['name'];
      
    } catch (e) {
      throw(e);
    }

  }

  static Future<void> updateLocation() {
    return null;
  }

  static Future<void> deleteLocation() {
    return null;
  }

  static Future<List<Map<String, dynamic>>> getLocations() {
    return null;
  }
}
