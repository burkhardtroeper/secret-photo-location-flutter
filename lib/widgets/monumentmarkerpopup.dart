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
    return Container(
      width: 200,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.network(monument.url, width: 200),
            Text(monument.title),
            Text(monument.description),
            Text(monument.date.toString()),
            //Text('${monument.lat}-${monument.long}'),
            TextButton(onPressed: () {popUpPressed(context);}, child: const Text('Bearbeiten')),
          ],
        ),
      ),
    );
  }
}