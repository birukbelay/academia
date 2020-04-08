import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
//my

import './product_edit.dart';
import '../../scoped_models/main_model.dart';

class ProductViewPage extends StatefulWidget {
  final MainModel model;

  ProductViewPage(this.model);

  @override
  State<StatefulWidget> createState() {

    return _ProductViewPageState();
  }

}

class _ProductViewPageState extends State<ProductViewPage>{
  @override
  initState(){
    widget.model.fetchMyProducts();
    super.initState();

  }







//========================= Widget EditButton ====================
  Widget _editButton(BuildContext context, int index, MainModel model) {

    return  IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          model.selectProduct(model.myProducts[index].id);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return ProductEditPage();
          }));
        },
      );

  }


  //  ----------------==== waring dialogue ========-----------
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
                  model.selectProduct(model.myProducts[index].id);
                  model.deleteProduct();

//                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        });
  }

//  ==============---------   Widget _listProduct ----------============
  Widget _listProduct(context, index, model) {
    return Dismissible(
      key: Key(model.myProducts[index].title),
      background: Container(
        color: Colors.red,
      ),


//      ---------------- ===  onDismissed Function ===== -------------------
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart) {
           _showWarningDialog(context, index, model);
        }
      },
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(model.myProducts[index].image),
            ),
            title: Text(model.myProducts[index].title),
            subtitle: Text('\$${model.myProducts[index].price}'),
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
        itemCount: model.myProducts.length,
      );
    },);

  }
}
