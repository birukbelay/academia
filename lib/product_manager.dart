import 'package:academia1/product_control.dart';
import 'package:flutter/material.dart';

// my imports
import 'package:academia1/products.dart';

class ProductManager extends StatelessWidget {

  final List<Map<String, String>> products;
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
          child: ProductControl(addProduct),
        ),
        Container(
          height: 300.0,
            child: Products(products, deleteProducts: deleteProduct)),

        ///adding products to our products widget
      ],
    );
  }
}
