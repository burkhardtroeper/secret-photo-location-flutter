import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:provider/provider.dart';
import '../models/monumentmarker.dart';
import '../widgets/monumentmarkerpopup.dart';

import '../models/monument.dart';

import './locationinput_screen.dart';

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

  late Future markersFuture;

  // @override
  // void initState() {
  //   super.initState();
  //   markersFuture = getMarkers();
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    markersFuture = getMarkers();
  }

  void newLocation(LatLng latlng) async {
    
    _popupLayerController.hideAllPopups();

    if (!_editMode) {
      return;
    }

    await Navigator.of(context).pushNamed(LocationInput.routeName, arguments: {
      'date': '',
      'lat': latlng.latitude.toString(),
      'long': latlng.longitude.toString()
    });
    // setState(() {
    //   _markers =
    //       Provider.of<LocationProvider>(context, listen: false).allMarkers as List<Marker>;
    // });
  }

  void toggleEditMode () {
    setState(() {
      _editMode = !_editMode;
    });
  }

  getMarkers () async {

    print('In getMarkers');
    List<Marker> tempListMarker = await Provider.of<LocationProvider>(context, listen: true).allMarkers;
    print(tempListMarker.length);
    return tempListMarker; 


  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {toggleEditMode();},
        child: const Icon(Icons.add),
        backgroundColor: _editMode ? Colors.red: Colors.blue,
        foregroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Stack(
        children: [
          FutureBuilder(
            future: Provider.of<LocationProvider>(context, listen: true).allMarkers,
            builder: (BuildContext context, snapshot) {    
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }              
              print(snapshot.data);
              return FlutterMap(
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
                  snapshot.data != null ?
                  PopupMarkerLayerWidget(
                    options: PopupMarkerLayerOptions(
                      popupController: _popupLayerController,
                      markers: snapshot.data as List<Marker>,
                      markerRotateAlignment:
                          PopupMarkerLayerOptions.rotationAlignmentFor(
                              AnchorAlign.top),
                      popupBuilder: (_, Marker marker) {
                        if (marker is MonumentMarker) {
                          return MonumentMarkerPopup(
                              marker.monument, _popupLayerController);
                        }
                        return const Card(child: Text('Not a monument'));
                      },
                    ),
                  ) : PopupMarkerLayerWidget(
                    options: 
                      PopupMarkerLayerOptions(
                        popupBuilder: (_, Marker marker) {
                          return const Card(child: Text('No locations yet'));                          
                        }
                      )
                    )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
