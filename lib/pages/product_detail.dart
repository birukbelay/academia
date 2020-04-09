import 'package:flutter/material.dart';
//import 'package:scoped_model/scoped_model.dart';

//my
//import '../scoped_models/main_model.dart';
import '../widgets/ui_element/title.dart';
import '../models/product.dart';
import '../widgets/product/product_fab.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  final bool fav = false;

  ProductDetailPage(this.product);

  Widget _appbar(BuildContext context, String title) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.favorite_border),
          color: fav
              ? Theme.of(context).accentColor
              : Theme.of(context).primaryColor,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildAdressPriceRow(price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Union Square, San fransisco',
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Text(
          '\$' + price.toString(),
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        )
      ],
    );
  }


//  TODO what is WillPopScope ???
  @override
  Widget build(BuildContext context) {
    return WillPopScope( onWillPop: (){
      Navigator.pop(context, false);
      return Future.value(false);
    },
      child: Scaffold(
        appBar: _appbar(context, product.title),
        body: Center(
          child: Column(
            children: <Widget>[
//              @Animation -->hero
              Hero(
                tag: product.id,
                child: FadeInImage(
                  image: NetworkImage(product.image),
                  height: 300.0,
                  fit: BoxFit.cover,
                  placeholder: AssetImage('assets/images/food/9.jpg'),
                ),
              ),
//
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: TitleDefault(product.title)),
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
//        ================ @@../widgets/products/product_fab.dart
        floatingActionButton: ProductFab(product),
      ),

    );
  }
}
