import 'package:flutter/material.dart';
class ProductCreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('Save'),
        onPressed: (){
          showModalBottomSheet(context: context, builder: (BuildContext context){
            return Center(
              child: Text('wow this is called modal'),
            );
          }
          );
        },
      ),
    );
  }
}