import 'package:flutter/material.dart';
import '../screens/main_screen.dart';

class StartScreen extends StatelessWidget {
  static const routeName = '/start-screen';

  //const StartScreen({ Key? key }) : super(key: key);

  buttonPressed (ctx) {
    Navigator.of(ctx).pushReplacementNamed(MainScreen.routeName);
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('SPL V0.0.1'),
      // ),
      body: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text('Special Foto Location', style: TextStyle(fontSize: 100)),
            TextButton(onPressed: () {buttonPressed(context);}, child: const Text('Button Text')),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.white,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.category),
      //       label: '1',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.category),
      //       label: '2',
      //     ),
      //   ],
      // ),
    );
  }
}
