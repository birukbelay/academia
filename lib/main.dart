
import 'package:flutter/material.dart';

//import 'package:flutter/rendering.dart';
// my import
import 'package:academia1/pages/auth.dart';
import 'package:academia1/pages/products_page.dart';
import 'package:academia1/pages/product_detail.dart';

import 'package:academia1/pages/product_admin.dart';

void main() {
//  debugPaintSizeEnabled = true;
//  debugPaintBaselinesEnabled =true;
//  debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
//  final Map startingProduct;
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  List<Map<String, dynamic>> _products = [];

  @override
//void initState() {
//  print('[product manager state] initState()');//
//  if (widget.startingProduct!=null){
//    _products.add(widget.startingProduct);
//  }
//  /// initializing the _products state//
//  super.initState();
//}

//@override
//void didUpdateWidget(ProductManager oldWidget) {
//  print('[ProductManager State] didUpdateWidget');
//  super.didUpdateWidget(oldWidget);
//}

  void _addProduct(Map product) {
    setState(() {
      _products.add(product);
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.deepOrange,
//          brightness: Brightness.dark,
      ),
//        home: AuthPage(),
      routes: {
        '/': (BuildContext context) =>
            HomePage(_products, _addProduct, _deleteProduct),
        '/admin': (BuildContext context) => AdminPage(_addProduct, _deleteProduct, _products),
        '/auth': (BuildContext context) => AuthPage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');
        if (pathElements[0] != '') {
          return null;
        }
        if (pathElements[1] == 'product') {
          final int index = int.parse(pathElements[2]);

          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ProductPage(
                _products[index]['title'], _products[index]['image']),
          );
        }
        return null;
      },

      onUnknownRoute: (RouteSettings settings){
        return MaterialPageRoute(
          builder: (BuildContext context)=>HomePage(_products, _addProduct, _deleteProduct),
        );
      },
    );
  }
}
