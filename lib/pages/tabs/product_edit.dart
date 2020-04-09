import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:io';

//my
import '../../models/product.dart';
import '../../scoped_models/main_model.dart';
import '../../widgets/helpers/ensure_visible.dart';
import '../../widgets/form_inputs/image.dart';
//import '../../widgets/form_inputs/location.dart';

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
    'image': null,
    'price': null,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _descriptionTextController =TextEditingController();
  final _titleTextController =TextEditingController();
  final _priceTextController =TextEditingController();

//  ===============================  Build title  =========================

  Widget _buildTitle(Product product) {
    if(product==null && _titleTextController.text.trim() == ''){
      _titleTextController.text='';
    }else if(product !=null && _titleTextController.text.trim()==''){
      _titleTextController.text=product.title;
    }
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode,
      child: TextFormField(
        focusNode: _titleFocusNode,
        controller: _titleTextController,
        decoration: InputDecoration(
          labelText: 'product name',
        ),
//        initialValue: product == null ? '' : product.title,
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


//  ========================================  Build Price =================

  Widget _buildPrice(Product product) {
    if(product==null && _priceTextController.text.trim() == ''){
      _priceTextController.text='';
    }else if(product !=null && _priceTextController.text.trim()==''){
      _priceTextController.text=product.price.toString();
    }
    return EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: TextFormField(
        focusNode: _priceFocusNode,
        controller: _priceTextController,
        decoration: InputDecoration(labelText: 'price', hintMaxLines: 6),
        keyboardType: TextInputType.number,
        obscureText: false,
//        initialValue: product == null ? '' : product.price.toString(),
        validator: (String value) {
//          this regExp accepts both comma and decimal as a valure
          if (value.isEmpty ||
              !RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]d+)?$').hasMatch(value)) {
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
    if(product==null && _descriptionTextController.text.trim() == ''){
      _descriptionTextController.text='';
    }else if(product !=null && _descriptionTextController.text.trim()==''){
      _descriptionTextController.text=product.description;
    }
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
        focusNode: _descriptionFocusNode,
        controller: _descriptionTextController,
        maxLines: 2,
        decoration: InputDecoration(labelText: 'description'),
//        initialValue: product == null ? '' : product.description.toString(),
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
              SizedBox(height: 10.0,),
              _buildPrice(product),
              _buildDescription(product),
              SizedBox(height: 10.0,),
              ImageInput(_setImage, product),
              SizedBox(height: 10.0,),

//              LocationInput(),
              SizedBox(height: 10.0,),

              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }


  void _setImage(File image){
    _formData['image']= image;
  }
void _showAlertDialog(String message){
  showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(message),
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
//  ======================= Function Edit item =========================

  void _submitForm(Function addProduct, Function updateProduct, selectProduct,
      [int selectedProductIndex]) {

    if (!_formKey.currentState.validate() || (_formData['image']==null && selectedProductIndex == -1) ){
      return;
    }
    _formKey.currentState.save();

//    adding a product

    if (selectedProductIndex == -1) {
      addProduct(_titleTextController.text, _formData['image'], _priceTextController.text.replaceFirst(RegExp(r','), '.'),
              _descriptionTextController.text)
          .then((bool success) {
            if(success){
              Navigator
                  .pushReplacementNamed(context, '/')
                  .then((_)=>selectProduct(null));
            }else{
              _showAlertDialog('error happened');
            }

      });
    } else {
//      FIXME i have changed some code on update product it might have errors
      updateProduct(_titleTextController.text, _formData['image'], _priceTextController.text.replaceFirst(RegExp(r','), '.'),
            _descriptionTextController.text)
          .then((bool success){

        if(success){
          Navigator
              .pushReplacementNamed(context, '/')
              .then((_)=>selectProduct(null));
        }else{
          _showAlertDialog('error happened');
        }
    });

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
