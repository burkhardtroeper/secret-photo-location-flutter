import 'package:flutter/material.dart';
// import '/screens/main_screen.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'dart:io';

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
  var _firstEntry = true;

  File? _storedImage;

  final _descriptionFocusNode = FocusNode();
  final _imageUrl = FocusNode();

  var data = Monument(
      title: '',
      description: '',
      lat: 0,
      long: 0,
      fileLink: '',
      date: DateTime.now().toString());

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) return;

    setState(() {
      _isLoading = true;
    });

    print('In _safeForm');

    print('Current filelink before formsave is ${data.fileLink}');

    _form.currentState!.save();

    print('Current filelink after formsave is ${data.fileLink}');

    if (_isInit) {
      print('Saving new filelink');
      print(data.fileLink);
      Provider.of<LocationProvider>(context, listen: false).addLocation(data);
    } else {
      print('Updating');
      print(data.title);
      Provider.of<LocationProvider>(context, listen: false)
          .updateLocation(data);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _takePhoto() async {
    final imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 600, maxHeight: 400);

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    // final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    data = Monument(
        title: data.title,
        description: data.description,
        camera: data.camera,
        lens: data.lens,
        aperture: data.aperture,
        exposureTime: data.exposureTime,
        iso: data.iso,
        lat: data.lat,
        long: data.long,
        fileLink: '${appDir.path}/$fileName',
        date: data.date);

    setState(() {
      _storedImage = imageFile;
    });
  }

  Future<void> _getPhoto() async {
    final imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: 600, maxHeight: 400);

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    await imageFile.copy('${appDir.path}/$fileName');

    final fileLink = '${appDir.path}/$fileName';

    print('New filelink ${fileLink}');

    data = Monument(
        title: data.title,
        description: data.description,
        camera: data.camera,
        lens: data.lens,
        aperture: data.aperture,
        exposureTime: data.exposureTime,
        iso: data.iso,
        lat: data.lat,
        long: data.long,
        fileLink: fileLink,
        date: data.date);

    print('... saved as ${data.fileLink}');

    setState(() {
      _storedImage = imageFile;
    });
  }

  Future<void> _deleteLocation() async {
    Provider.of<LocationProvider>(context, listen: false)
        .deleteLocation(data.date);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _imageUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_firstEntry == true) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      final dateString = args['date'].toString();

      if (dateString == '') {
        print('Creating new location');
        final lat = double.parse(args['lat'].toString());
        final long = double.parse(args['long'].toString());
        data = Monument(
            title: '',
            description: '',
            camera: '',
            lens: '',
            aperture: '',
            exposureTime: '',
            iso: '',
            lat: lat,
            long: long,
            fileLink: '',
            date: DateTime.now().toString());
      } else {
        final date = DateTime.parse(dateString);
        data = Provider.of<LocationProvider>(context).findByDate(dateString);
        print('Data from existing location');
        print('filelink is ${data.fileLink}');
        _storedImage = File(data.fileLink);
        _isInit = false;
      }

      _firstEntry = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: _isInit
            ? const Text('New Photo Location')
            : const Text('Edit Photo Location'),
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
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    child: _storedImage != null
                        ? Image.file(
                            _storedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : const Text('No Image selected'),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ElevatedButton(
                            onPressed: _takePhoto,
                            child: const Text('Take Photo')),
                        ElevatedButton(
                            onPressed: _getPhoto,
                            child: const Text('Load Photo')),
                        Form(
                          key: _form,
                          child: ListView(
                            children: <Widget>[
                              TextFormField(
                                initialValue: data.title,
                                decoration:
                                    const InputDecoration(labelText: 'Title'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
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
                                      camera: data.camera,
                                      lens: data.lens,
                                      aperture: data.aperture,
                                      exposureTime: data.exposureTime,
                                      iso: data.iso,
                                      lat: data.lat,
                                      long: data.long,
                                      fileLink: data.fileLink,
                                      date: data.date);
                                },
                              ),
                              TextFormField(
                                initialValue: data.description,
                                decoration: const InputDecoration(
                                    labelText: 'Description'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
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
                                      camera: data.camera,
                                      lens: data.lens,
                                      aperture: data.aperture,
                                      exposureTime: data.exposureTime,
                                      iso: data.iso,
                                      lat: data.lat,
                                      long: data.long,
                                      fileLink: data.fileLink,
                                      date: data.date);
                                },
                              ),
                              TextFormField(
                                initialValue: data.camera,
                                decoration:
                                    const InputDecoration(labelText: 'Camera'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                // validator: (value) {
                                //   if (value!.isEmpty) {
                                //     return ('Please enter valid image URL');
                                //   }
                                //   return null;
                                // },
                                onSaved: (value) {
                                  data = Monument(
                                      title: data.title,
                                      description: data.description,
                                      camera: value.toString(),
                                      lens: data.lens,
                                      aperture: data.aperture,
                                      exposureTime: data.exposureTime,
                                      iso: data.iso,
                                      lat: data.lat,
                                      long: data.long,
                                      fileLink: data.fileLink,
                                      date: data.date);
                                },
                              ),
                              TextFormField(
                                initialValue: data.lens,
                                decoration:
                                    const InputDecoration(labelText: 'Lens'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                // validator: (value) {
                                //   if (value!.isEmpty) {
                                //     return ('Please enter valid image URL');
                                //   }
                                //   return null;
                                // },
                                onSaved: (value) {
                                  data = Monument(
                                      title: data.title,
                                      description: data.description,
                                      camera: data.camera,
                                      lens: value.toString(),
                                      aperture: data.aperture,
                                      exposureTime: data.exposureTime,
                                      iso: data.iso,
                                      lat: data.lat,
                                      long: data.long,
                                      fileLink: data.fileLink,
                                      date: data.date);
                                },
                              ),
                              TextFormField(
                                initialValue: data.aperture,
                                decoration: const InputDecoration(
                                    labelText: 'Aperture'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                // validator: (value) {
                                //   if (value!.isEmpty) {
                                //     return ('Please enter valid image URL');
                                //   }
                                //   return null;
                                // },
                                onSaved: (value) {
                                  data = Monument(
                                      title: data.title,
                                      description: data.description,
                                      camera: data.camera,
                                      lens: data.lens,
                                      aperture: value.toString(),
                                      exposureTime: data.exposureTime,
                                      iso: data.iso,
                                      lat: data.lat,
                                      long: data.long,
                                      fileLink: data.fileLink,
                                      date: data.date);
                                },
                              ),
                              TextFormField(
                                initialValue: data.exposureTime,
                                decoration: const InputDecoration(
                                    labelText: 'Exposure Time'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                // validator: (value) {
                                //   if (value!.isEmpty) {
                                //     return ('Please enter valid image URL');
                                //   }
                                //   return null;
                                // },
                                onSaved: (value) {
                                  data = Monument(
                                      title: data.title,
                                      description: data.description,
                                      camera: data.camera,
                                      lens: data.lens,
                                      aperture: data.aperture,
                                      exposureTime: value.toString(),
                                      iso: data.iso,
                                      lat: data.lat,
                                      long: data.long,
                                      fileLink: data.fileLink,
                                      date: data.date);
                                },
                              ),
                              TextFormField(
                                initialValue: data.iso,
                                decoration:
                                    const InputDecoration(labelText: 'ISO'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                // validator: (value) {
                                //   if (value!.isEmpty) {
                                //     return ('Please enter valid image URL');
                                //   }
                                //   return null;
                                // },
                                onSaved: (value) {
                                  data = Monument(
                                      title: data.title,
                                      description: data.description,
                                      camera: data.camera,
                                      lens: data.lens,
                                      aperture: data.aperture,
                                      exposureTime: data.exposureTime,
                                      iso: value.toString(),
                                      lat: data.lat,
                                      long: data.long,
                                      fileLink: data.fileLink,
                                      date: data.date);
                                },
                              ),
                              ElevatedButton(
                                  onPressed: _deleteLocation,
                                  child: const Text('Delete Location')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
