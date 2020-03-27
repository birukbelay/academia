import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
//my
import '../widgets/ui_element/drawer.dart';
import '../widgets/product/product_card_container.dart';
import '../scoped_models/main_model.dart';



class ProductsPage extends StatelessWidget {





  Widget _drawerWidget(BuildContext context){
    return Drawer(
      child: DrawerUi(),
    );
  }

  Widget _appBar(){
    return AppBar(
      title: Text('academics'),
      actions: <Widget>[
        ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
          return IconButton(
            icon: Icon(model.displayFavOnly? Icons.favorite : Icons.favorite_border),
            onPressed: (){
              model.toggleDisplayFavorites();
            },
          );
        },

        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _drawerWidget(context),
      appBar: _appBar(),
      body: Products(),

    );
  }
}
