import 'package:flutter/material.dart';

class ProductEditPage extends StatefulWidget {
  Function addProduct;
  Function updateProduct;
  final Map<String, dynamic> product;
  final int productIndex;

  ProductEditPage(
      {this.addProduct, this.updateProduct, this.product, this.productIndex});

  @override
  State<StatefulWidget> createState() {
    return _ProductsEditPage();
  }
}

//=========================  state of the widget  ==============================

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

//  ===============================  Build title  =========================

  Widget _buildTitle() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'product name',
      ),
      initialValue: widget.product == null ? '' : widget.product['title'],
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

//  ============================  build image  ==========================

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

//  ========================================  Build Price =================

  Widget _buildPrice() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'price', hintMaxLines: 6),
      keyboardType: TextInputType.number,
      obscureText: false,
      initialValue:
          widget.product == null ? '' : widget.product['price'].toString(),
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

//  =============================   Build desccription  ====================

  Widget _buildDescription() {
    return TextFormField(
      maxLines: 2,
      decoration: InputDecoration(labelText: 'description'),
      initialValue: widget.product == null
          ? ''
          : widget.product['description'].toString(),
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return 'desc required';
        }
      },
      onSaved: (String value) {
        _product['description'] = value;
      },
    );
  }

// ============================   BuildPageContent ========================
  Widget _buildPageContent(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = (deviceWidth - targetWidth) / 2;

    return GestureDetector(
      onTap: () {  FocusScope.of(context).requestFocus(FocusNode());   },
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

//  ============================  build bottom modal ====================
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

//  ======================= Function Edit item =========================

  void _editItem() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    if (widget.product == null) {
      widget.addProduct(_product);
    } else {
      widget.updateProduct(widget.productIndex, _product);
    }

    Navigator.pushReplacementNamed(context, '/');

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return _buildModal();
        });
  }

//===============  -------- @ override rendering the widget -------  ========
  @override
  Widget build(BuildContext context) {
    final Widget pageContent = _buildPageContent(context);

//if widget.product == null ? pageContent  : Scaffold
    return widget.product == null
        ? pageContent
        : Scaffold(
            appBar: AppBar(
              title: Text('edit Product'),
            ),
            body: pageContent,
          );
  }
}
