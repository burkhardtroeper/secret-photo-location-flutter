import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'monument.dart';

class MonumentMarker extends Marker {
  MonumentMarker({required this.monument})
      : super(
          anchorPos: AnchorPos.align(AnchorAlign.top),
          height: Monument.size,
          width: Monument.size,
          point: LatLng(monument.lat, monument.long),
          builder: (BuildContext ctx) => Icon(Icons.camera_alt),
        );

  final Monument monument;
}