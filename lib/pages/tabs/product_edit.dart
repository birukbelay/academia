import 'package:flutter/material.dart';

class ProductEditPage extends StatefulWidget {
  Function addProduct;
  Function updateItem;
  final Map<String, dynamic> product;

  ProductEditPage({this.addProduct, this.updateItem, this.product});

  @override
  State<StatefulWidget> createState() {
    return _ProductsEditPage();
  }
}

class _ProductsEditPage extends State<ProductEditPage> {

  final Map<String, dynamic> _product = {
    'title': '',
    'description': '',
    'image': 'image',
    'price': 0,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//  bool _switchs;
  Function addProduct;

  Widget _buildTitle() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'product title',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'title required';
        }
      },
      onSaved: (String value) {
        _product['title'] = value;
      },
    );
  }

  Widget _buildImage() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'image no',
      ),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'this value is a number and required';
        }
      },
      onSaved: (String value) {
        _product['image'] = 'assets/images/food/' + value + '.jpg';
      },
    );
  }

  Widget _buildPrice() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'price', hintMaxLines: 6),
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'this value is a number and required';
        }
      },
      onSaved: (String value) {
        _product['price'] = double.parse(value);
      },
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      maxLines: 2,
      decoration: InputDecoration(labelText: 'description'),
      onSaved: (String value) {
        _product['description'] = value;
      },
    );
  }

  Widget _buildModal() {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(_product['image']),
          ListTile(
            leading: Image.asset(_product['image']),
            title: Text(_product['title']),
          ),
        ],
      ),
    );
  }

  void _editItem() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    widget.addProduct(_product);

    Navigator.pushReplacementNamed(context, '/');

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return _buildModal();
        });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = (deviceWidth - targetWidth) / 2;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding),
            children: <Widget>[
              _buildTitle(),
              _buildImage(),
              _buildPrice(),
              _buildDescription(),
              RaisedButton(
                child: Text('Save'),
                onPressed: _editItem,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
