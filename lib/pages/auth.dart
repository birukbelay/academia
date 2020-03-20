import 'package:academia1/pages/product_admin.dart';
import 'package:flutter/material.dart';

//
//import 'package:academia1/pages/home.dart';
//import 'package:academia1/pages/product_create.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('auth'),

      ),
      body: Center(
        child: RaisedButton(
          child: Text('login'),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (BuildContext context) => AdminPage()),
            );
          },
        ),
      ),
    );
  }
}
