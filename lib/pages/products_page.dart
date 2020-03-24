import 'package:flutter/material.dart';
//my
import '../widgets/ui_element/drawer.dart';
import '../widgets/product/product_card_container.dart';



class HomePage extends StatelessWidget {





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
      body: Products(),

    );
  }
}
