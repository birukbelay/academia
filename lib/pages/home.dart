
import 'package:flutter/material.dart';

import 'package:academia1/product_manager.dart';


class HomePage extends StatelessWidget {
  final List<Map<String, String>> products;
  final Function addProduct;
  final Function deleteProduct;
  HomePage(this.products, this.addProduct, this.deleteProduct);

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
                Navigator.pushReplacementNamed(context, '/admin');

              },
            )
          ],
        ),
      ),
      appBar: AppBar(


        title: Text('academics'),
      ),
      body: ProductManager(products, addProduct, deleteProduct),

    );
  }
}
