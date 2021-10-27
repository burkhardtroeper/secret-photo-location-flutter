import 'package:flutter/material.dart';
import '/screens/main_screen.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';

import '../models/monument.dart';

class LocationInput extends StatefulWidget {
  static const routeName = '/locationinput-screen';

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  var _isInit = true;

  final _descriptionFocusNode = FocusNode();
  final _imageUrl = FocusNode();

  var data = Monument(title: '', lat: 0, long: 0, url: '', date: DateTime.now());

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) return;

    setState(() {
      _isLoading = true;
    });

    print('In _safeForm');
    _form.currentState!.save();

    if (_isInit) {
      print('Saving new');
      print(data.title);
      Provider.of<LocationProvider>(context, listen: false).addLocation(data);
    } else {
      print('Updating');
      print(data.title);
      Provider.of<LocationProvider>(context, listen: false).updateLocation(data);
    }
        
    setState(() {
      _isLoading = false;
    });

  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _imageUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final dateString = args['date'].toString();    

    try {
      final date = DateTime.parse(dateString);
      data = Provider.of<LocationProvider>(context).findByDate(date);
      _isInit = false;
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
                      keyboardType: TextInputType.text,
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
                      keyboardType: TextInputType.text,
                      focusNode: _descriptionFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_imageUrl);
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
                      keyboardType: TextInputType.text,
                      focusNode: _imageUrl,
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
    );
  }
}
