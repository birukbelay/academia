import 'package:flutter/material.dart';
//
import 'package:academia1/pages/tabs/product_create.dart';
import 'package:academia1/pages/tabs/product_view.dart';
//import 'package:academia1/pages/home.dart';

class AdminPage extends StatelessWidget {

  Function addProduct;
  Function deleteProduct;
  AdminPage(this.addProduct, this.deleteProduct);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length:2,
      child: Scaffold(
        drawer: Drawer(
            child: Column(
              children: <Widget>[
                AppBar(
                  automaticallyImplyLeading: false,
                  title: Text('app bar'),
                ),
                ListTile(
                  title: Text('All products'),
                  onTap:() {
                    Navigator.pushReplacementNamed(context, '/');

                  },
                )
              ],
            ),
        ),
        appBar: AppBar(
          title: Text('admin'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: 'Create product',
              ),
              Tab(
                icon: Icon(Icons.list),
                text: 'my Products',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[ProductCreatePage(addProduct, deleteProduct), ProductViewPage()],
        ),
      ),
    );
  }
}
