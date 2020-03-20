import 'package:flutter/material.dart';



class Products extends StatelessWidget {
  final List<Map> products;
  final Function deleteProducts;

  Products(this.products, {this.deleteProducts}) {
    ///recieving products in the constructor function
    print('[product W] constructor');
  }

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: [
          Image.asset(products[index]['image']),
          Text(products[index]['title']),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text('Details'),
                onPressed: () =>
                    Navigator.pushNamed<bool>(context, '/product/' + index.toString())
                    .then((bool value) {
                  if (value) {
                    deleteProducts(index);
                    print(value);
                  }
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    Widget productCard;

    if (products.length > 0) {
      productCard = ListView.builder(
        itemBuilder: _buildProductItem,
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

    return _buildProductList();
  }
}
