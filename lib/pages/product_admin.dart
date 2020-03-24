import 'package:academia1/widgets/ui_element/drawer.dart';
import 'package:flutter/material.dart';
//

import 'package:academia1/pages/tabs/product_edit.dart';
import 'package:academia1/pages/tabs/product_view.dart';
//import 'package:academia1/pages/products_page.dart';

class AdminPage extends StatelessWidget {

  Function addProduct;
  Function deleteProduct;
  Function updateProduct;
  final List<Map<String, dynamic>> products;

  AdminPage(this.addProduct, this.updateProduct, this.deleteProduct, this.products);




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
            ProductEditPage(addProduct: addProduct,),
            ProductViewPage(products, updateProduct, deleteProduct),

          ],
        ),
      ),
    );
  }
}
