import 'package:flutter/material.dart';
import '../models/monument.dart';
import 'dart:io';

import '../screens/locationinput_screen.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

class MonumentMarkerPopup extends StatelessWidget {
  const MonumentMarkerPopup(this.monument, this.popupLayerController);
  final Monument monument;
  final PopupController popupLayerController;

  void updatePressed (context) async {

    print(monument.fileLink);
    await Navigator.of(context).pushNamed(LocationInput.routeName, arguments: {'date':  monument.date.toString(), 'lat': '', 'long': ''});
    popupLayerController.hideAllPopups();

  }

  @override
  Widget build(BuildContext context) {
    print('Building popup');
    print('filelink here: ${monument.fileLink}');
    return Card(
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: 200,
          height: 500,
          child: Column(
            children: <Widget>[
              Image.file(File(monument.fileLink)),
              ListTile(
                title: Text(monument.title),
                subtitle: Text(
                  monument.description,
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      monument.camera,
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                    Text(
                      monument.lens,
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                    Text(
                      monument.aperture,
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                    Text(
                      monument.exposureTime,
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                    Text(
                      monument.iso,
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(                    
                    onPressed: () {
                      updatePressed(context);
                    },
                    child: const Text('Edit'),
                  ),
                ],
              ),
              
            ],
          ),
        ),
      );


  }
}