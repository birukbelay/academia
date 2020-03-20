import 'package:academia1/pages/product_admin.dart';
import 'package:flutter/material.dart';

import 'package:academia1/product_manager.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('app bar'),
            ),
            ListTile(
              title: Text('All products'),
              onTap:() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AdminPage()));

              },
            )
          ],
        ),
      ),
      appBar: AppBar(


        title: Text('academics'),
      ),
      body: ProductManager(),
    );
  }
}
