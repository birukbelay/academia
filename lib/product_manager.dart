import 'package:academia1/product_control.dart';
import 'package:flutter/material.dart';

// my imports
import 'package:academia1/products.dart';

class ProductManager extends StatefulWidget {
  final Map startingProduct;

  ProductManager({this.startingProduct}) {
    print('[product manager Widget] constructor');
  }

  @override
  State<StatefulWidget> createState() {
    print('[product manager Widget] CreateState()');

    return _ProductManagerState();
  }
}

class _ProductManagerState extends State<ProductManager> {
  List<Map> _products = [];
//  List<String> _products = const[]; //if we dont want to edit or modify the value

  @override

  void initState() {
    print('[product manager state] initState()');

    if (widget.startingProduct!=null){
      _products.add(widget.startingProduct);
    }
    /// initializing the _products state

    super.initState();
  }

  @override
  void didUpdateWidget(ProductManager oldWidget) {
    print('[ProductManager State] didUpdateWidget');
    super.didUpdateWidget(oldWidget);
  }

  void _addProducts(Map product) {
    setState(() {
      _products.add(product);
    });
  }

  void _deleteProduct(int index){
      setState(() {
        _products.removeAt(index);
      });
  }

  @override
  Widget build(BuildContext context) {
    print('[product manager state] build()');

    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10.0),
          child: ProductControl(_addProducts),
        ),
        Container(
          height: 300.0,
            child: Products(_products, deleteProducts: _deleteProduct)),

        ///adding products to our products widget
      ],
    );
  }
}
