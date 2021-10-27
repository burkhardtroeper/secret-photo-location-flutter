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
  static const routeName = '/main-screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PopupController _popupLayerController = PopupController();

  bool _editMode = false;

  List<Marker> _markers = [];

  void newLocation(LatLng latlng) async {
    
    if (!_editMode) {
      _popupLayerController.hideAllPopups();
      return;
    }
    
    _popupLayerController.hideAllPopups();
    await Navigator.of(context).pushNamed(LocationInput.routeName, arguments: {
      'date': '',
      'lat': latlng.latitude.toString(),
      'long': latlng.longitude.toString()
    });
    setState(() {
      _markers =
          Provider.of<LocationProvider>(context, listen: true).allMarkers;
    });
  }

  void toggleEditMode () {
    setState(() {
      _editMode = !_editMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    _markers = Provider.of<LocationProvider>(context, listen: true).allMarkers;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {toggleEditMode();},
        child: Icon(Icons.add),
        backgroundColor: _editMode ? Colors.red: Colors.blue,
        foregroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              zoom: 5.0,
              center: LatLng(44.421, 10.404),
              onTap: (pos, latlng) {
                newLocation(latlng);
              },
            ),
            children: [
              TileLayerWidget(
                options: TileLayerOptions(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
              ),
              PopupMarkerLayerWidget(
                options: PopupMarkerLayerOptions(
                  popupController: _popupLayerController,
                  markers: _markers,
                  markerRotateAlignment:
                      PopupMarkerLayerOptions.rotationAlignmentFor(
                          AnchorAlign.top),
                  popupBuilder: (_, Marker marker) {
                    if (marker is MonumentMarker) {
                      return MonumentMarkerPopup(
                          marker.monument, _popupLayerController);
                    }
                    return Card(child: const Text('Not a monument'));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );

    // return FlutterMap(
    //   options: MapOptions(
    //     zoom: 5.0,
    //     center: LatLng(44.421, 10.404),
    //     onTap: (pos, latlng) {
    //         newLocation(latlng);
    //       },
    //   ),
    //   children: [
    //     TileLayerWidget(
    //       options: TileLayerOptions(
    //         urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
    //         subdomains: ['a', 'b', 'c'],
    //       ),
    //     ),
    //     PopupMarkerLayerWidget(
    //       options: PopupMarkerLayerOptions(
    //         popupController: _popupLayerController,
    //         markers: _markers,
    //         markerRotateAlignment:
    //             PopupMarkerLayerOptions.rotationAlignmentFor(AnchorAlign.top),
    //         popupBuilder: (_, Marker marker) {
    //           if (marker is MonumentMarker) {
    //             return MonumentMarkerPopup(marker.monument, _popupLayerController);
    //           }
    //           return Card(child: const Text('Not a monument'));
    //         },
    //       ),
    //     ),
    //   ],
    // );
  }
}
