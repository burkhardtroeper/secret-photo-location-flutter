import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

class SingleLocation {

  final String title;
  final String description;
  final String camera;
  final String lens;
  final String aperture;
  final String exposureTime;
  final LatLng coordinates;
  final String url;
  final DateTime date;
  
  const SingleLocation({
    @required this.title,
    @required this.description,
    @required this.camera,
    @required this.lens,
    @required this.aperture,
    @required this.exposureTime,
    @required this.coordinates,
    @required this.url,
    @required this.date
  });

}