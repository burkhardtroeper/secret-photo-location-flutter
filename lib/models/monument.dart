// import 'package:flutter/foundation.dart';
// import 'package:latlong2/latlong.dart';

class Monument {

  static const double size = 25;

  final String title;
  final String description;
  final String camera;
  final String lens;
  final String aperture;
  final String exposureTime;
  final String iso;
  final double lat;
  final double long;
  final String fileLink;
  final String date;
  
  const Monument({
    required this.title,
    required this.description,
    this.camera = '',
    this.lens = '',
    this.aperture = '',
    this.exposureTime = '',
    this.iso = '',
    required this.lat,
    required this.long,
    required this.fileLink,
    required this.date,
  });

}