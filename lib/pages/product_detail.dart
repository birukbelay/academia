import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

//my
import '../scoped_models/products.dart';
import '../widgets/ui_element/title.dart';
import '../models/product.dart';


class ProductPage extends StatelessWidget {
  final int productIndex;

  final bool fav=false;

  ProductPage(this.productIndex);


Widget _appbar(BuildContext context, String title){
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.favorite_border),
          color: fav ? Theme.of(context).accentColor:Theme.of(context).primaryColor,
          onPressed: () {
          },
        ),
      ],
    );
}

  Widget _buildAdressPriceRow(price){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Union Square, San fransisco',
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text('|', style: TextStyle(color: Colors.grey),),
        ),
        Text('\$' + price.toString(), style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),)

      ],
    );
  }
  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<ProductsModel>(builder: (BuildContext context, Widget child, ProductsModel model){
      final Product product = model.products[productIndex];
      return Scaffold(
        appBar: _appbar(context, product.title),
        body: Center(
          child: Column(
            children: <Widget>[
              Image.asset(product.image),
              Container(
                  padding: EdgeInsets.all(10.0), child: TitleDefault(product.title)),
              _buildAdressPriceRow(product.price),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    },);
  }
}
