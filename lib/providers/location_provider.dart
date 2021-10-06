import 'package:flutter/material.dart';

import 'package:latlong2/latlong.dart';

import '../models/locations.dart';


class LocationProvider with ChangeNotifier {

  final List <SingleLocation> _locations = [

    SingleLocation(
      title: 'Location 1',
      description: 'Description 1',
      camera: 'Nikon D800', 
      lens: '85mm',
      aperture: '2.8',
      exposureTime: '1/250',
      coordinates: LatLng(44.421, 10.404),
      url: 'http://www.6real.de',
      date: DateTime.utc(2018, 11, 9)
    ),
    SingleLocation(
      title: 'Location 2',
      description: 'Description 2',
      camera: 'Nikon D850', 
      lens: '50mm',
      aperture: '3.5',
      exposureTime: '1/250',
      coordinates: LatLng(45.683, 10.839),
      url: 'http://www.6real.de',
      date: DateTime.utc(2019, 11, 9)
    ),
    SingleLocation(
      title: 'Location 3',
      description: 'Description 3',
      camera: 'Nikon Z6', 
      lens: '20mm',
      aperture: '2.8',
      exposureTime: '1/250',
      coordinates: LatLng(45.246, 5.783),
      url: 'http://www.6real.de',
      date: DateTime.utc(2020, 11, 9)
    ),
  ];

  List<SingleLocation> get allLocations {

    return [..._locations];

  }

  SingleLocation findByTitle(String title) {

    return _locations.firstWhere((element) => element.title == title);

  }

  void addLocation () {


    notifyListeners();

  }


  void deleteLocation () {



    notifyListeners();

  }

}