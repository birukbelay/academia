import 'package:flutter/material.dart';

//i
import './product_card.dart';

class Products extends StatelessWidget {
  final List<Map> products;
  final Function deleteProducts;

  Products(this.products, {this.deleteProducts}) {
    ///recieving products in the constructor function
    print('[product W] constructor');
  }



  Widget _productList() {
    Widget productCard;

    if (products.length > 0) {
      productCard = ListView.builder(
        itemBuilder: (BuildContext context, int index)=>ProductCard(products[index], index, deleteProducts),
        itemCount: products.length,
      );
    } else if (products.length == 0) {
      productCard = Center(child: Text('no products found'));
    } else {
      productCard = Container();
    }
    return productCard;
  }

  @override
  Widget build(BuildContext context) {
    print('[product W] build() ');

    return _productList();
  }
}
