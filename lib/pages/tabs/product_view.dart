import 'package:academia1/pages/tabs/product_edit.dart';
import 'package:flutter/material.dart';

class ProductViewPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  ProductViewPage(this.products);

  Widget _listProduct(context, index) {
    return ListTile(
      leading: Image.asset(products[index]['image']),
      title: Text(products[index]['title']),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return ProductEditPage(product: products[index]);
          }));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          _listProduct(context, index),
      itemCount: products.length,
    );
  }
}
