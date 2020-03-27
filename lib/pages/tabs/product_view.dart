import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
//my

import './product_edit.dart';
import '../../scoped_models/main_model.dart';

class ProductViewPage extends StatelessWidget {


  _showWarningDialog(BuildContext context, int index, model) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure'),
            content: Text('this action cant be undone'),
            actions: <Widget>[
              FlatButton(
                child: Text('Discard'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Delete'),
                onPressed: () {
                  Navigator.pop(context);
                  model.selectProduct(index);
                  model.deleteProduct();

//                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        });
  }





//========================= Widget EditButton ====================
  Widget _editButton(BuildContext context, int index, MainModel model) {

    return  IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          model.selectProduct(index);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return ProductEditPage();
          }));
        },
      );

  }

//  =========================   Widget _listProduct ====================
  Widget _listProduct(context, index, model) {
    return Dismissible(
      key: Key(model.allProducts[index].title),
      background: Container(
        color: Colors.red,
      ),

//      ================ onDismissed Function -------------------
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart) {
           _showWarningDialog(context, index, model);
        }
      },
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(model.allProducts[index].image),
            ),
            title: Text(model.allProducts[index].title),
            subtitle: Text('\$${model.allProducts[index].price}'),
            trailing: _editButton(context, index, model),
          ),
          Divider()
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
      return  ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            _listProduct(context, index, model),
        itemCount: model.allProducts.length,
      );
    },);

  }
}
