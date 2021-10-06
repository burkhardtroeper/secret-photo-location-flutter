import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './screens/start_screen.dart';
import './screens/main_screen.dart';

import './providers/location_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()
        ),
      ],
      child: MaterialApp(
        title: 'SPL V0.0.1',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
        initialRoute: '/',
        routes: {
          '/': (ctx) => StartScreen(),
          MainScreen.routeName: (ctx) => MainScreen(),
        },
      ),
    );
  }
}
