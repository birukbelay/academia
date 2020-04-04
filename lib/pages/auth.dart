import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

//my
import '../scoped_models/main_model.dart';
//import 'package:academia1/pages/products_page.dart';

enum AuthMode { SignUp, Login }

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPage();
  }
}

class _AuthPage extends State<AuthPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

//  ================================Widgets=====================================
//==============================================================================

// ================   The decoration image for the background  ===
  DecorationImage decorationImageWidget() {
    return DecorationImage(
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
        image: AssetImage('assets/images/food/9.jpg'));
  }

//   ================   the Email Widget  ================
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
        return null;
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
      controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password invalid';
        }
        return null;
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

//    =============== password confirm ==========

  Widget _passwordConfirmWidget() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'conferm  Password',
          filled: true,
          fillColor: Colors.white12),
      obscureText: true,
      validator: (String value) {
        if (_passwordTextController.text != value) {
          return 'Password do not match';
        }
        return null;
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

//=================== accept switch==========
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

//=================================Functions====================================
//  ============================================================================

  void _submitForm(Function login, Function signup) async {
    if (!_formKey.currentState.validate() || !_formData['acceptTerms']) {
      return;
    }
    _formKey.currentState.save();
    Map<String, dynamic> succesInformation;
    if (_authMode == AuthMode.Login) {
      succesInformation =
          await login(_formData['email'], _formData['password']);
    } else {
      succesInformation =
          await signup(_formData['email'], _formData['password']);
    }

    if (succesInformation['sucess']) {
      Navigator.pushReplacementNamed(context, '/admin');
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('an error has occored'),
              content: Text(succesInformation['message']),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
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
                  _authMode == AuthMode.SignUp
                      ? _passwordConfirmWidget()
                      : Container(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildAcceptSwitch(),
                  FlatButton(
                    child: Text(
                        'switch to ${_authMode == AuthMode.Login ? 'Signup' : "Login"}'),
                    onPressed: () {
                      setState(() {
                        _authMode = _authMode == AuthMode.Login
                            ? AuthMode.SignUp
                            : AuthMode.Login;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ScopedModelDescendant<MainModel>(
                    builder:
                        (BuildContext context, Widget child, MainModel model) {
                      return model.isLoading
                          ? CircularProgressIndicator()
                          : RaisedButton(
                              child: Text(_authMode == AuthMode.Login
                                  ? 'Login'
                                  : 'Signup'),
                              onPressed: () =>
                                  _submitForm(model.login, model.signup),
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
