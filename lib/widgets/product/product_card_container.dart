import 'package:flutter/material.dart';

//i
import 'package:scoped_model/scoped_model.dart';

import './product_card.dart';
import '../../models/product.dart';
import '../../scoped_models/main_model.dart';

class Products extends StatelessWidget {




  Widget _productList(List<Product> products) {
    Widget productCard;

    if (products.length > 0) {
      productCard = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(products[index], index),
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
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
          return _productList(model.displayedFavoriteProducts);
    }, );
  }
}
