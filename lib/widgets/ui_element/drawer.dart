import 'package:flutter/material.dart';

class DrawerUi extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return   Column(
        children: <Widget>[
//            appbar for all products
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('app bar'),

          ),
          ListTile(
            leading: Icon(Icons.supervised_user_circle),
            title: Text('All products'),
            onTap:() {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          ),
          ListTile(
            leading:Icon(Icons.verified_user) ,
            title: Text('Auth'),
            onTap:() {
              Navigator.pushReplacementNamed(context, '/auth');
            },
          ),
          ListTile(
            title: Text('All products'),
            onTap:() {
              Navigator.pushReplacementNamed(context, '/');

            },
          )
       ],
      );

  }
}
