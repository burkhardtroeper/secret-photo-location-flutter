import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';


import '../models/monument.dart';
import '../models/monumentmarker.dart';


class LocationProvider with ChangeNotifier {

  final List <Monument> _locations = [

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

  List<Monument> get allLocations {

    return [..._locations];

  }

  List<Marker> get allMarkers {

    List<Marker> tempMarker = [];

    _locations.forEach((location) {

      var tempLocation = MonumentMarker(monument: Monument(title: location.title, lat: location.lat, long: location.long, url: location.url, date: location.date));

      tempMarker.add(tempLocation);

     });

     return tempMarker;

    // <Marker>[
    //   MonumentMarker(monument: Monument(
    //     title: 'Titel 1',
    //     url: 'https://cdn.lifestyleasia.com/wp-content/uploads/2019/10/21224220/Winer-Parisienne.jpg',
    //     lat: 48.137648311296,
    //     long: 11.57983264273121,
    //     date: DateTime.now(),
    //     // date: DateTime.utc(2018, 01, 5)
    //   )),
    // ],

  }

  Monument findByTitle(String title) {

    return _locations.firstWhere((element) => element.title == title);

  }

  void addLocation (Monument newLocation) {

    _locations.add(newLocation);

    notifyListeners();

  }


  void deleteLocation (String deleteTitle) {

    final existingLocationIndex = _locations.indexWhere((element) => element.title == deleteTitle);
    // var existingLocation = _locations[existingLocationIndex];
    _locations.removeAt(existingLocationIndex);

    notifyListeners();

  }

}