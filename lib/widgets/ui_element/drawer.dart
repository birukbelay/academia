import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped_models/main_model.dart';
class DrawerUi extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  ScopedModelDescendant<MainModel> (builder:(context, child , model){
      return Column(
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
              model.isAuthenticated ?
              Navigator.pushReplacementNamed(context, '/admin'):
              Navigator.pushReplacementNamed(context, '/auth');
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
    });

  }
}
