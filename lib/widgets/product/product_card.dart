import 'package:academia1/widgets/ui_element/title.dart';
import 'package:flutter/material.dart';
//
import './price.dart';

class ProductCard extends StatelessWidget {

  final Map<String, dynamic> product;
  final int index;
  final Function deleteProduct;

  ProductCard(this.product, this.index, this.deleteProduct);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.asset(product['image']),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              TitleDefault(product['title']),
                SizedBox(
                  width: 10.0,
                ),
                Price(product['price'].toString()),

              ],
            ),

          ),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width:1.0),
              borderRadius: BorderRadius.circular(4.0),

            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
              child: Text('Union Street'),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[

              IconButton(
                icon: Icon(Icons.info),
                color: Theme.of(context).accentColor,
                onPressed: () => Navigator.pushNamed<bool>(
                    context, '/product/' + index.toString())
                    .then((bool value) {
                  if (value) {
                    deleteProduct(index);
                    print(value);
                  }
                }),
              ),

              IconButton(
                  icon: Icon(Icons.favorite_border),
                  color: Colors.red,
                  onPressed: () {}
              ),
            ],
          ),
        ],
      ),
    );
  }
}
