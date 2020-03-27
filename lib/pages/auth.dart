import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
//my
import '../scoped_models/main_model.dart';
//import 'package:academia1/pages/products_page.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPage();
  }
}

class _AuthPage extends State<AuthPage> {
  final Map<String, dynamic> _formData ={
  'email' : null,
  'password' : null,
  'acceptTerms' : false,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


// =========================  The decoration image for the background  ================
  DecorationImage decorationImageWidget() {
    return DecorationImage(
        fit: BoxFit.cover,
        colorFilter:
        ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
        image: AssetImage('assets/images/food/9.jpg'));
  }
//   =========================  the Email Widget  ======================
  Widget emailWidget() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'E- Mail', filled: true, fillColor: Colors.white12),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

//  ==================  The password Widget  ====================

   Widget passwordWidget() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white12),
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password invalid';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }
//=================== accceot switch==========
  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
      title: Text('Accept Terms'),
    );
  }
//======================  ApppBar Widget  =====================
  Widget _appbar() {
    return AppBar(
      title: Text('auth'),
    );
  }



  void _submitForm(Function login) {
    if (!_formKey.currentState.validate() || !_formData['acceptTerms']) {
      return;
    }
    _formKey.currentState.save();
    login(_formData['email'], _formData['password']);
    Navigator.pushReplacementNamed(context, '/admin');
  }

//  =====================  --- MAIN BUILD METHOD --- =================
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: _appbar(),
      body: Container(
        decoration: BoxDecoration(
//          decoration image
            image: decorationImageWidget()),
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  emailWidget(),
                  SizedBox(
                    height: 10.0,
                  ),
                  passwordWidget(),
                  _buildAcceptSwitch(),
                  ScopedModelDescendant(builder: (BuildContext context, Widget child, MainModel model){
                   return RaisedButton(
                      child: Text('login'),
                      onPressed: () =>_submitForm(model.login),
                    );
                  },

                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
