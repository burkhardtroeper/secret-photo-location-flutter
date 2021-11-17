import 'package:flutter/material.dart';
import '../screens/main_screen.dart';

class StartScreen extends StatelessWidget {
  static const routeName = '/start-screen';

  //const StartScreen({ Key? key }) : super(key: key);

  buttonPressed(ctx) {
    Navigator.of(ctx).pushReplacementNamed(MainScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Special Photo Locations'),
        ),
        body: Container(
            child: Stack(
          children: [
            const Image(
              image: AssetImage(
                  'assets/images/startscreenbackground.jpg'),
              alignment: Alignment.center,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Container(                            
              alignment: const Alignment(0, 0.9),
              child: ElevatedButton(                                
                  onPressed: () {
                    buttonPressed(context);
                  },
                  child: const Text('Weiter')),
            ),
          ],
        )));
  }
}
