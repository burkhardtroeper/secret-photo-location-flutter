import 'package:flutter/material.dart';
import '../models/monument.dart';

import '../screens/locationinput_screen.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

class MonumentMarkerPopup extends StatelessWidget {
  const MonumentMarkerPopup(this.monument, this.popupLayerController);
  final Monument monument;
  final PopupController popupLayerController;

  void popUpPressed (context) async {

    await Navigator.of(context).pushNamed(LocationInput.routeName, arguments: {'date':  monument.date.toString(), 'lat': '', 'long': ''});
    popupLayerController.hideAllPopups();

  }

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: 200,
          height: 400,
          child: Column(
            children: <Widget>[
              Image.network(monument.url),
              ListTile(
                title: Text(monument.title),
                subtitle: Text(
                  monument.description,
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Hier kommen technische Daten rein ...',
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    textColor: const Color(0xFF6200EE),
                    onPressed: () {
                      popUpPressed(context);
                    },
                    child: const Text('Bearbeiten'),
                  ),
                   ],
              ),
              
            ],
          ),
        ),
      );


  }
}