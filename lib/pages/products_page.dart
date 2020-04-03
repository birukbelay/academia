import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

//my
import '../widgets/ui_element/drawer.dart';
import '../widgets/product/product_card_container.dart';
import '../scoped_models/main_model.dart';

class ProductsPage extends StatefulWidget {
  final MainModel model;

  ProductsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductsPageState();
  }
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  initState() {
    widget.model.fetchProducts();
    super.initState();
  }

  Widget _drawerWidget(BuildContext context) {
    return Drawer(
      child: DrawerUi(),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text('academics'),
      actions: <Widget>[
        ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
            return IconButton(
              icon: Icon(model.displayFavOnly
                  ? Icons.favorite
                  : Icons.favorite_border),
              onPressed: () {
                model.toggleDisplayFavorites();
              },
            );
          },
        )
      ],
    );
  }

  Widget _buildProducts() {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        Widget content = Center(
          child: Text('no products found'),
        );
        if (model.displayedFavoriteProducts.length > 0 && !model.isLoading) {
          content = Products();
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(onRefresh: model.fetchProducts,
            child: content,);

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _drawerWidget(context),
      appBar: _appBar(),
      body: _buildProducts(),
    );
  }
}
