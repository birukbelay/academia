import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

//import 'package:flutter/rendering.dart';
// my import
import './pages/auth.dart';
import './pages/products_page.dart';
import './pages/product_detail.dart';
import './pages/product_admin.dart';

import './scoped_models/main_model.dart';

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

  @override
  Widget build(BuildContext context) {
    final MainModel model =MainModel();
    return ScopedModel<MainModel>(
      model:model,/*  */
      child: MaterialApp(
      title: 'Flutter Demo',

//      ==================  Theme ---------------------
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.deepOrange,
//          brightness: Brightness.dark,
      ),
//        home: AuthPage(),

//    ============================Routes --------------
      routes: {
        '/': (BuildContext context) =>
            ProductsPage(model),
        '/admin': (BuildContext context) =>
            AdminPage(model),
        '/auth': (BuildContext context) => AuthPage(),
      },

//      ======================  on generate Routes ------------
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');
        if (pathElements[0] != '') {
          return null;
        }
        if (pathElements[1] == 'product') {
          final int index = int.parse(pathElements[2]);

          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ProductPage(index),
          );
        }
        return null;
      },

//      ================  =============  On unknown Route

      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (BuildContext context) =>
              ProductsPage(model),
        );
      },
    ),);
  }
}
