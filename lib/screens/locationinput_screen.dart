import 'package:flutter/material.dart';
import '/screens/main_screen.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import 'package:latlong2/latlong.dart';

import '../models/monument.dart';

class LocationInput extends StatefulWidget {
  static const routeName = '/locationinput-screen';

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  final _form = GlobalKey<FormState>();
  var _isLoading = false;

  final _descriptionFocusNode = FocusNode();
  final _cameraFocusNode = FocusNode();
  final _lensFocusNode = FocusNode();

  Monument data = Monument(title: '', lat: 0, long: 0, url: '', date: DateTime.now());

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) return;

    setState(() {
      _isLoading = true;
    });

    print('In _safeForm');

    Provider.of<LocationProvider>(context, listen: false).addLocation(data);
    
    setState(() {
      _isLoading = false;
    });

  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _cameraFocusNode.dispose();
    _lensFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final title = args['title'].toString();

    try {
      data = Provider.of<LocationProvider>(context).findByTitle(title);
    } catch (e) {
      final lat = double.parse(args['lat'].toString());
      final long = double.parse(args['long'].toString());
      data = Monument(
          title: 'NEW LOCATION',
          lat: lat,
          long: long,
          url: '',
          date: DateTime.now());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Photo Location'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _saveForm();
              Navigator.pop(context);
            },
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: data.title,
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ('Please enter title');
                        }
                        return null;
                      },
                      onSaved: (value) {
                        data = Monument(
                            title: value.toString(),
                            description: data.description,
                            lat: data.lat,
                            long: data.long,
                            url: data.url,
                            date: data.date);
                      },
                    ),
                    TextFormField(
                      initialValue: data.description,
                      decoration: InputDecoration(labelText: 'Description'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_cameraFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ('Please enter a description');
                        }
                        return null;
                      },
                      onSaved: (value) {
                        data = Monument(
                            title: data.title,
                            description: value.toString(),
                            lat: data.lat,
                            long: data.long,
                            url: data.url,
                            date: data.date);
                      },
                    ),
                    TextFormField(
                      initialValue: data.url,
                      decoration: InputDecoration(labelText: 'Image URL'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ('Please enter valid image URL');
                        }
                        return null;
                      },
                      onSaved: (value) {
                        data = Monument(
                            title: data.title,
                            description: data.description,
                            lat: data.lat,
                            long: data.long,
                            url: value.toString(),
                            date: data.date);
                      },
                    ),
                  ],
                ),
              ),
            ),

      //   Container(
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     Text('Title'),
      //     Text(data.title),
      //     Text('Lat long'),
      //     Text(data.lat.toString()),
      //     Text(data.long.toString()),
      //     TextButton(
      //         onPressed: () {
      //           Navigator.pop(context);
      //         },
      //         child: const Text('Return'))
      //   ],
      // ),
    );
  }
}
