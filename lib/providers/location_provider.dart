import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';


import '../models/monument.dart';
import '../models/monumentmarker.dart';


class LocationProvider with ChangeNotifier {

  List <Monument> _locations = [

    Monument(
      title: 'Hofbräuhaus München',
      description: 'Von Janos Kertesz',
      lat: 48.137648311296,
      long: 11.57983264273121,
      url: 'https://source.unsplash.com/user/c_v_r/200x100',
      date: DateTime.utc(2018, 01, 5)
    ),
    Monument(
      title: 'Hofbräuhaus München 2',
      description: 'Description 2',
      lat: 47.137648311296,
      long: 11.57983264273121,
      url: 'https://source.unsplash.com/user/c_v_r/200x100',
      date: DateTime.utc(2019, 11, 9)
    ),
    Monument(
      title: 'Hofbräuhaus München 3',
      description: 'Description 3',
      lat: 49.137648311296,
      long: 11.57983264273121,
      url: 'https://source.unsplash.com/user/c_v_r/200x100',
      date: DateTime.utc(2020, 11, 9)
    ),
  ];

  List <Marker> _markers = [];

  List<Monument> get allLocations {

    return [..._locations];

  }

  List<Marker> get allMarkers {

    _markers = [];
    
    _locations.forEach((location) {

      var tempLocation = MonumentMarker(monument: Monument(title: location.title, lat: location.lat, long: location.long, url: location.url, date: location.date));

      _markers.add(tempLocation);

     });

     print('getting all markers');

    return [..._markers];

  }

  Monument findByDate(DateTime date) {

    return _locations.firstWhere((element) => element.date == date);

  }

  void addLocation (Monument newLocation) {

    _locations.add(newLocation);
    var tempMarker = MonumentMarker(monument: Monument(title: newLocation.title, lat: newLocation.lat, long: newLocation.long, url: newLocation.url, date: newLocation.date));
    _markers.add(tempMarker);

    print('New location and marker added');

    notifyListeners();

  }

  void updateLocation (Monument location) {

    final locationIndex = _locations.indexWhere((loc) => loc.date == location.date);
    if (locationIndex >= 0) {
      _locations[locationIndex] = location;
      var tempMarker = MonumentMarker(monument: Monument(title: location.title, lat: location.lat, long: location.long, url: location.url, date: location.date));
      _markers[locationIndex] = tempMarker;
      print(tempMarker.monument.title);
    }

    print('Location and marker updated');
    

    notifyListeners();

  }


  void deleteLocation (String deleteTitle) {

    final existingLocationIndex = _locations.indexWhere((element) => element.title == deleteTitle);
    // var existingLocation = _locations[existingLocationIndex];
    _locations.removeAt(existingLocationIndex);

    notifyListeners();

  }

}