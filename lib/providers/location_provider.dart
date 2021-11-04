import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';

import 'package:flutter_map/flutter_map.dart';

import '../models/monument.dart';
import '../models/monumentmarker.dart';

class LocationProvider with ChangeNotifier {
  List<Monument> _locations = [];

  List<Marker> _markers = [];

  Future <List<Monument>> allLocations () async {
    
    await fetchAndSetLocations();  
    return [..._locations];
  
  }

  Future<List<Marker>> get allMarkers async {
    
    _markers = [];

    await fetchAndSetLocations();

    _locations.forEach((location) {
      var tempLocation = MonumentMarker(
          monument: Monument(
              title: location.title,
              description: location.description,
              lat: location.lat,
              long: location.long,
              fileLink: location.fileLink,
              date: location.date));

      _markers.add(tempLocation);
    });

    print('getting all markers');

    return [..._markers];

  }

  Monument findByDate(DateTime date) {
    return _locations.firstWhere((element) => element.date == date);
  }

  void addLocation(Monument newLocation) {
    _locations.add(newLocation);
    var tempMarker = MonumentMarker(
        monument: Monument(
            title: newLocation.title,
            description: newLocation.description,
            lat: newLocation.lat,
            long: newLocation.long,
            fileLink: newLocation.fileLink,
            date: newLocation.date));
    _markers.add(tempMarker);

    print('New location and marker added');

    notifyListeners();

    DBHelper.insert('user_locations', {
      'date': newLocation.date,
      'title': newLocation.title,
      'description': newLocation.description,
      'lat': newLocation.lat,
      'long': newLocation.long,
      'filelink': newLocation.fileLink,
    });
  }

  void updateLocation(Monument location) {
    final locationIndex =
        _locations.indexWhere((loc) => loc.date == location.date);
    if (locationIndex >= 0) {
      _locations[locationIndex] = location;
      var tempMarker = MonumentMarker(
          monument: Monument(
              title: location.title,
              description: location.description,
              lat: location.lat,
              long: location.long,
              fileLink: location.fileLink,
              date: location.date));
      _markers[locationIndex] = tempMarker;
      print(tempMarker.monument.title);
    }

    print('Location and marker updated');

    notifyListeners();
  }

  void deleteLocation(String deleteTitle) {
    final existingLocationIndex =
        _locations.indexWhere((element) => element.title == deleteTitle);
    // var existingLocation = _locations[existingLocationIndex];
    _locations.removeAt(existingLocationIndex);

    notifyListeners();
  }

  Future<void> fetchAndSetLocations() async {
    final dataList = await DBHelper.getData('user_locations');
    _locations = dataList
        .map((location) => Monument(
              date: location['date'],
              title: location['title'],
              description: location['description'],
              lat: location['lat'],
              long: location['long'],
              fileLink: location['filelink'],
            ))
        .toList();

    notifyListeners();
  }
}
