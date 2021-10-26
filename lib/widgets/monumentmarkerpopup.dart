import 'package:flutter/material.dart';
import '../models/monument.dart';

import '../screens/locationinput_screen.dart';

class MonumentMarkerPopup extends StatelessWidget {
  const MonumentMarkerPopup({Key? key, required this.monument})
      : super(key: key);
  final Monument monument;




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
            TextButton(onPressed: () {Navigator.of(context).pushNamed(LocationInput.routeName, arguments: {'title':  monument.title, 'lat': '', 'long': ''});}, child: const Text('Bearbeiten')),
          ],
        ),
      ),
    );
  }
}