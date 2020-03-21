import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  Function addItem;
  Function deleteItem;

  ProductCreatePage(this.addItem, this.deleteItem);

  @override
  State<StatefulWidget> createState() {
    return _ProductsCreatePage();
  }
}

class _ProductsCreatePage extends State<ProductCreatePage> {
  String title;

  double price;
  String image;
  String description;
//  bool _switchs;
  Function addProduct;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.all(20.0),
      child: ListView(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: 'product title',
            ),
            onChanged: (String value) {
              setState(() {
                title = value;
              });
            },
          ),
//          image no Text field
//        SwitchListTile(
//          value: _switchs,
//          onChanged: (bool value){
//            setState(() {
//              _switchs=value;
//            });
//          },
//          title: Text('terms'),
//        ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'image no',
            ),
            onChanged: (String value) {
              setState(() {
                image = 'assets/images/food/' + value + '.jpg';
              });
            },
          ),
//          TextField(
//            decoration: InputDecoration(labelText: 'price', hintMaxLines: 6),
//            keyboardType: TextInputType.number,
//            onChanged: (String value) {
//              setState(() {
//                price = double.parse(value);
//              });
//            },
//          ),
//          TextField(
//            maxLines: 2,
//            decoration: InputDecoration(labelText: 'description'),
//            onChanged: (String value) {
//              setState(() {
//                description = value;
//              });
//            },
//          ),
          RaisedButton(
            child: Text('Save'),
            onPressed: () {
              final Map<String, dynamic> product = {
                'title': title,
                'description': description,
                'image': image,
                'price': price,
              };
              widget.addItem(product);
              print(image);
              Navigator.pushReplacementNamed(context, '/');
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Card(
                      child: Column(
                        children: <Widget>[
                          Image.asset(image),
                          ListTile(
                            leading: Image.asset(image),
                            title: Text(title),
                          ),
                        ],
                      ),
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}
