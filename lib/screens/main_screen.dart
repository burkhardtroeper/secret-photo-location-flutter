import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:provider/provider.dart';
import '../models/monumentmarker.dart';
import '../widgets/monumentmarkerpopup.dart';

import '../models/monument.dart';

import './locationinput_screen.dart';

//import '../example_popup.dart';

import '../providers/location_provider.dart';

class MainScreen extends StatefulWidget {
  //const MainScreen({ Key? key }) : super(key: key);

  static const routeName = '/main-screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  /// Used to trigger showing/hiding of popups.
  final PopupController _popupLayerController = PopupController();

  @override
  Widget build(BuildContext context) {
    // List<Monument> locations =
    //     Provider.of<LocationProvider>(context).allLocations;

    return FlutterMap(
      options: MapOptions(
        zoom: 5.0,
        center: LatLng(44.421, 10.404),
        onTap: (pos, latlng) {
            _popupLayerController.hideAllPopups();
            Navigator.of(context).pushNamed(LocationInput.routeName, arguments: {'title': 'null', 'lat': latlng.latitude.toString(), 'long': latlng.longitude.toString()});
          },
      ),
      children: [
        TileLayerWidget(
          options: TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
        ),
        PopupMarkerLayerWidget(
          options: PopupMarkerLayerOptions(
            popupController: _popupLayerController,

            // markers: getMarkers(locations),
            markers: Provider.of<LocationProvider>(context).allMarkers,
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
           
            markerRotateAlignment:
                PopupMarkerLayerOptions.rotationAlignmentFor(AnchorAlign.top),

            // popupBuilder: (BuildContext context, Marker marker) =>
            //     ExamplePopup(marker),

            popupBuilder: (_, Marker marker) {
              
              if (marker is MonumentMarker) {
                return MonumentMarkerPopup(monument: marker.monument);
              }

              return Card(child: const Text('Not a monument'));
              
            }

            // popupBuilder: (_, Marker marker) {
            //   if (marker is MonumentMarker) {
            //     return MonumentMarkerPopup(monument: marker.monument);
            //   }
            //   return Card(child: const Text('Not a monument'));
            // },


          ),
        ),
      ],
    );
  }


//   List<Marker> getMarkers(locations) {
    
//     var locationList = locations
//         .map(
//           (location) => MonumentMarker(
//             monument: Monument(
//               name: location.title,
//               imagePath: location.url,
//               lat: location.lat,
//               long: location.long,
//               date: location.date
//           ),
//         ));
  
//     return List<Marker>.from(locationList);
//   }
}

// class Monument {
//   // static const double size = 25;

//   // Monument({
//   //   required this.name,
//   //   required this.imagePath,
//   //   required this.lat,
//   //   required this.long,
//   // });

//   // final String name;
//   // final String imagePath;
//   // final double lat;
//   // final double long;

//   static const double size = 25;

//   final String title;
//   final String description;
//   final String camera;
//   final String lens;
//   final String aperture;
//   final String exposureTime;
//   final double lat;
//   final double long;
//   final String url;
//   final DateTime date;
  
//   const Monument({
//     required this.title,
//     this.description = '',
//     this.camera = '',
//     this.lens = '',
//     this.aperture = '',
//     this.exposureTime = '',
//     required this.lat,
//     required this.long,
//     required this.url,
//     required this.date,
//   });


// }

// class MonumentMarker extends Marker {
//   MonumentMarker({required this.monument})
//       : super(
//           anchorPos: AnchorPos.align(AnchorAlign.top),
//           height: Monument.size,
//           width: Monument.size,
//           point: LatLng(monument.lat, monument.long),
//           builder: (BuildContext ctx) => Icon(Icons.camera_alt),
//         );

//   final Monument monument;
// }

// class MonumentMarkerPopup extends StatelessWidget {
//   const MonumentMarkerPopup({Key? key, required this.monument})
//       : super(key: key);
//   final Monument monument;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 200,
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Image.network(monument.url, width: 200),
//             Text(monument.title),
//             Text('${monument.lat}-${monument.long}'),
//           ],
//         ),
//       ),
//     );
//   }
// }
