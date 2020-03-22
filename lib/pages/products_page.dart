import 'package:flutter/material.dart';
//
import 'package:academia1/widgets/ui_element/drawer.dart';
import 'package:academia1/widgets/product/products_list.dart';


class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function addProduct;
  final Function deleteProduct;
  HomePage(this.products, this.addProduct, this.deleteProduct);



  Widget _drawerWidget(BuildContext context){
    return Drawer(
      child: DrawerUi(),
    );
  }

  Widget _appBar(){
    return AppBar(
      title: Text('academics'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: _drawerWidget(context),
      appBar: _appBar(),
      body: Products(products, deleteProducts: deleteProduct),

    );
  }
}
