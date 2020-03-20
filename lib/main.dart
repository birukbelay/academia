import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// my import
 import 'package:academia1/pages/home.dart';


void main(){
//  debugPaintSizeEnabled = true;
//  debugPaintBaselinesEnabled =true;
//  debugPaintPointersEnabled = true;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.blue,
          accentColor: Colors.deepOrange,
//          brightness: Brightness.dark,
        ),
        home: HomePage(),
    );
  }
}


