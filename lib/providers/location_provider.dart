import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';


import '../models/monument.dart';
import '../models/monumentmarker.dart';


class LocationProvider with ChangeNotifier {

  List <Monument> _locations = [

    // Monument(
    //   title: 'Hofbräuhaus München',
    //   description: 'Weltbekannt für gutes Bier, gutes Essen und schlechtes Publikum',
    //   lat: 48.137648311296,
    //   long: 11.57983264273121,
    //   url: 'https://cdn.muenchen-p.de/.imaging/stk/responsive/image300/dms/sw/c/hofbraeuhaus1/12-hofbraeuhaus/document/12-hofbraeuhaus.jpg',
    //   date: DateTime.utc(2018, 01, 5)
    // ),
    // Monument(
    //   title: 'Brandenburger Tor',
    //   description: 'Das Wahrzeichen Berlins, vielleicht sogar von ganz Deutschland',
    //   lat: 52.516292,
    //   long: 13.377483,
    //   url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Brandenburger_Tor_abends.jpg/1200px-Brandenburger_Tor_abends.jpg',
    //   date: DateTime.utc(2019, 11, 9)
    // ),
    // Monument(
    //   title: 'Rathaus Bocholt',
    //   description: 'Das hässlichste Rathaus der Welt',
    //   lat: 51.836980053741605,
    //   long: 6.61186028774274,
    //   url: 'http://www.borkenerzeitung.de/Bilder/Das-Rathaus-am-Berliner-Platz-Viele-Bocholter-wollen-das-310095m.jpg',
    //   date: DateTime.utc(2020, 11, 9)
    // ),
  ];

  List <Marker> _markers = [];

  List<Monument> get allLocations {

    return [..._locations];

  }

  List<Marker> get allMarkers {

    _markers = [];
    
    _locations.forEach((location) {

      var tempLocation = MonumentMarker(monument: Monument(title: location.title, description: location.description, lat: location.lat, long: location.long, fileLink: location.fileLink, date: location.date));

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
    var tempMarker = MonumentMarker(monument: Monument(title: newLocation.title, description: newLocation.description, lat: newLocation.lat, long: newLocation.long, fileLink: newLocation.fileLink, date: newLocation.date));
    _markers.add(tempMarker);

    print('New location and marker added');

    notifyListeners();

  }

  void updateLocation (Monument location) {

    final locationIndex = _locations.indexWhere((loc) => loc.date == location.date);
    if (locationIndex >= 0) {
      _locations[locationIndex] = location;
      var tempMarker = MonumentMarker(monument: Monument(title: location.title, description: location.description, lat: location.lat, long: location.long, fileLink: location.fileLink, date: location.date));
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