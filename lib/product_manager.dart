import 'package:flutter/material.dart';

// my imports
import 'package:academia1/products.dart';

class ProductManager extends StatelessWidget {

  final List<Map<String, dynamic>> products;
  final Function addProduct;
  final Function deleteProduct;

  ProductManager(this.products, this.addProduct, this.deleteProduct);


    @override
  Widget build(BuildContext context) {
    print('[product manager state] build()');

    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10.0),

        ),
        Expanded(
            child: Products(products, deleteProducts: deleteProduct)),

        ///adding products to our products widget
      ],
    );
  }
}
