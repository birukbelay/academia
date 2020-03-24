import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

//my
import 'package:academia1/models/product.dart';
import '../../scoped_models/products.dart';

class ProductEditPage extends StatefulWidget {
  Function addProduct;
  Function updateProduct;
  final Product product;
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
  final Map<String, dynamic> _formData = {
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
      initialValue: widget.product == null ? '' : widget.product.title,
      validator: (String value) {
        if (value.isEmpty) {
          return 'title required';
        }
      },
      onSaved: (String value) {
        _formData['title'] = value;
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
        _formData['image'] = 'assets/images/food/' + value + '.jpg';
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
          widget.product == null ? '' : widget.product.price.toString(),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'this value is a number and required';
        }
      },
      onSaved: (String value) {
        _formData['price'] = double.parse(value);
      },
    );
  }

//  =============================   Build desccription  ====================

  Widget _buildDescription() {
    return TextFormField(
      maxLines: 2,
      decoration: InputDecoration(labelText: 'description'),
      initialValue:
          widget.product == null ? '' : widget.product.description.toString(),
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return 'desc required';
        }
      },
      onSaved: (String value) {
        _formData['description'] = value;
      },
    );
  }

  //  ============================  build bottom modal ====================
  Widget _buildModal() {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(_formData['image']),
          ListTile(
            leading: Image.asset(_formData['image']),
            title: Text(_formData['title']),
          ),
        ],
      ),
    );
  }

  Widget _submitMessage() {
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget widget, ProductsModel model) {
        return RaisedButton(
            child: Text('Save'),
            onPressed: () =>
                _editItem(model.addProduct, model.updateProduct)
        );
      },
    );
  }

// ============================   BuildPageContent ========================
  Widget _buildPageContent(BuildContext context) {
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
              _submitMessage(),
            ],
          ),
        ),
      ),
    );
  }

//  ======================= Function Edit item =========================

  void _editItem(Function addProduct, Function updateProduct) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    var product = new Product(
        title: _formData['title'],
        image: _formData['image'],
        price: _formData['price'],
        description: _formData['description']);

    if (widget.product == null) {
    addProduct(product);
    } else {
    updateProduct(widget.productIndex, product);
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
