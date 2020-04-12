import 'package:flutter/material.dart';

final ThemeData _androidTheme =ThemeData(
  primarySwatch: Colors.blue,
  accentColor: Colors.deepOrange,
//          brightness: Brightness.dark,
);

final ThemeData _iosTheme =ThemeData(
  primarySwatch: Colors.grey,
  accentColor: Colors.deepOrange,
//          brightness: Brightness.dark,
);

ThemeData getAdaptiveTheme(context){
  return Theme.of(context).platform == TargetPlatform.android ? _androidTheme : _iosTheme;
}