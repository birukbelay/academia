import 'package:flutter/material.dart';

import 'package:academia1/product_manager.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('academics'),
      ),
      body: ProductManager(),
    );
  }
}
