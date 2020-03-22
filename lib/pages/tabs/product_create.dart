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

  Widget _buildTitle() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'product title',
      ),
      onChanged: (String value) {
        setState(() {
          title = value;
        });
      },
    );
  }

  Widget _buildImage() {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'image no',
      ),
      onChanged: (String value) {
        setState(() {
          image = 'assets/images/food/' + value + '.jpg';
        });
      },
    );
  }

  Widget _buildPrice() {
    return TextField(
      decoration: InputDecoration(labelText: 'price', hintMaxLines: 6),
      keyboardType: TextInputType.number,
      onChanged: (String value) {
        setState(() {
          price = double.parse(value);
        });
      },
    );
  }

  Widget _buildDescription() {
    return TextField(
      maxLines: 2,
      decoration: InputDecoration(labelText: 'description'),
      onChanged: (String value) {
        setState(() {
          description = value;
        });
      },
    );
  }

  Widget _buildModal() {
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
  }

  void _addItem() {
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
          return _buildModal();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.all(20.0),
      child: ListView(
        children: <Widget>[
          _buildTitle(),
          _buildImage(),
          _buildPrice(),
          _buildDescription(),
          RaisedButton(
            child: Text('Save'),
            onPressed: _addItem,
          ),
        ],
      ),
    );
  }
}
