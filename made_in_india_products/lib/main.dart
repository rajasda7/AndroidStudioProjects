import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:made_in_india_products/screens/HomeScreen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Made in india',
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
// Instances
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

// UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70.withOpacity(0.9),
      body: SafeArea(
        child: Container(
          child: Center(
            child: FutureBuilder(
              future: _initialization,
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return Text('Went Wrong');
                }

                if(snapshot.connectionState == ConnectionState.done){
                  return HomeScreen();
                }

                return CircularProgressIndicator();
              },
            ),
          ),
        )
        ,
      ),
    );
  }

}


