
import 'package:academia1/widgets/ui_element/drawer.dart';
import 'package:flutter/material.dart';
//

import './tabs/product_edit.dart';
import './tabs/product_view.dart';
import '../scoped_models/main_model.dart';
//import 'package:academia1/pages/products_page.dart';

class AdminPage extends StatelessWidget {

  final MainModel model;
  AdminPage(this.model);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length:2,
      child: Scaffold(

        drawer: Drawer(
            child: DrawerUi(),
        ),
        appBar: AppBar(
          title: Text('admin'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: 'Edit product',
              ),
              Tab(
                icon: Icon(Icons.list),
                text: 'my Products',
              ),


            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ProductEditPage(),
            ProductViewPage(model),

          ],
        ),
      ),
    );
  }
}
