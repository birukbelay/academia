import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

//my
import '../../models/product.dart';
import '../../scoped_models/main_model.dart';
import '../../widgets/helpers/ensure_visible.dart';

class ProductEditPage extends StatefulWidget {
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
    'image': 'assets/images/food/9.jpg',
    'price': null,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

//  ===============================  Build title  =========================

  Widget _buildTitle(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'product name',
        ),
        initialValue: product == null ? '' : product.title,
        validator: (String value) {
          if (value.isEmpty) {
            return 'title required';
          }
          return null;
        },
        onSaved: (String value) {
          _formData['title'] = value;
        },
      ),
    );
  }

//  ============================  build image  ==========================

//  ========================================  Build Price =================

  Widget _buildPrice(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: TextFormField(
        decoration: InputDecoration(labelText: 'price', hintMaxLines: 6),
        keyboardType: TextInputType.number,
        obscureText: false,
        initialValue: product == null ? '' : product.price.toString(),
        validator: (String value) {
          if (value.isEmpty ||
              !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
            return 'this value is a number and required';
          }
          return null;
        },
        onSaved: (String value) {
          _formData['price'] = double.parse(value);
        },
      ),
    );
  }

//  =============================   Build desccription  ====================

  Widget _buildDescription(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
        maxLines: 2,
        decoration: InputDecoration(labelText: 'description'),
        initialValue: product == null ? '' : product.description.toString(),
        validator: (String value) {
          if (value.isEmpty || value.length < 5) {
            return '* description must be > 5 letters';
          }
          return null;
        },
        onSaved: (String value) {
          _formData['description'] = value;
        },
      ),
    );
  }

  //  ============================  build bottom modal ====================
  Widget _buildModal() {
    return ListTile(
      leading: Image.asset(_formData['image']),
      title: Text(_formData['title']),
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget widget, MainModel model) {
        return model.isLoading
            ? Center(child: CircularProgressIndicator())
            : RaisedButton(
                child: Text('Save'),
                textColor: Colors.white,
                onPressed: () => _submitForm(
                    model.addProduct,
                    model.updateProduct,
                    model.selectProduct,
                    model.selectedProductIndex));
      },
    );
  }

// ============================   BuildPageContent ========================
  Widget _buildPageContent(BuildContext context, Product product) {
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
              _buildTitle(product),
              _buildPrice(product),
              _buildDescription(product),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

//  ======================= Function Edit item =========================

  void _submitForm(Function addProduct, Function updateProduct, selectProduct,
      [int selectedProductIndex]) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    if (selectedProductIndex == -1) {
      addProduct(_formData['title'], _formData['image'], _formData['price'],
              _formData['description'])
          .then((bool sucess) {
            if(sucess){
              Navigator
                  .pushReplacementNamed(context, '/')
                  .then((_)=>selectProduct(null));
            }else{
              showDialog(
                  context: context,
                  builder: (context){
                return AlertDialog(
                  title: Text('error happened'),
                  content: Text('please try again'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: ()=>Navigator.of(context).pop(),
                      child: Text('Okay'),
                    )
                  ],
                );
              });
            }

      });
    } else {
      updateProduct(_formData['title'], _formData['image'], _formData['price'],
              _formData['description'])
          .then((_) => Navigator.pushReplacementNamed(context, '/')
              .then((_) => selectProduct(null)));
    }

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return _buildModal();
        });
  }

//===============  -------- @ override rendering the widget -------  ========
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget widget, MainModel model) {
        final Widget pageContent =
            _buildPageContent(context, model.selectedProduct);

        //if model.product == null ? pageContent  : Scaffold
        return model.selectedProductIndex == -1
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text('edit Product'),
                ),
                body: pageContent,
              );
      },
    );
  }
}
