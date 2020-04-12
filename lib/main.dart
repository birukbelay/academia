import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
//import 'package:map_view/map_view.dart';

//import 'package:flutter/rendering.dart';
// my import
import './pages/auth.dart';
import './pages/products_page.dart';
import './pages/product_detail.dart';
import './pages/product_admin.dart';
import './models/product.dart';
import './widgets/helpers/custom_route.dart';
import './shared/adaptive_theme.dart';

import './scoped_models/main_model.dart';

void main() {
//  debugPaintSizeEnabled = true;
//  debugPaintBaselinesEnabled =true;
//  debugPaintPointersEnabled = true;
//MapView.setApiKey('AIzaSyA9kB2jWY0qBS726IxFFNheV0ylqZs-Tiw');
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
  final MainModel _model = MainModel();
  bool _isAuthenticated= false;

  @override
  void initState() {
    _model.userSubect.listen((bool isAuthenticated){
      setState((){
        _isAuthenticated=isAuthenticated;
      });
    });
//    _model.autoAuthenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      /*  */
      child: MaterialApp(
        title: 'Flutter Demo',
//      ==================  Theme ---------------------
        theme: getAdaptiveTheme(context),
//        home: AuthPage(),

//    ============================Routes --------------
        routes: {
          '/': (BuildContext context) => ProductsPage(_model),
          '/admin': (BuildContext context) =>_isAuthenticated? AdminPage(_model):AuthPage() ,
          '/auth': (BuildContext context) => _isAuthenticated? ProductsPage(_model) :AuthPage()  ,

        },

//      ======================  on generate Routes ------------
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product') {
//          final String productId = pathElements[2];
            final Product product =
                _model.allProducts.firstWhere((Product product) {
              return product.id == product.id;
            });
//          model.selectProduct(productId);
            return CustomRouteFade<bool>(
              builder: (BuildContext context) => ProductDetailPage(product),
            );
          }
          return null;
        },

//      ================  =============  On unknown Route

        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) => ProductsPage(_model),
          );
        },
      ),
    );
  }
}
