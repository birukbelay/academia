import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

//my
import '../scoped_models/main_model.dart';
import '../models/auth.dart';
//import 'package:academia1/pages/products_page.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPage();
  }
}

class _AuthPage extends State<AuthPage> with TickerProviderStateMixin {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  // @Animation 1.1 -->declare  the animation
  AnimationController _controller;
  Animation<Offset> _slideAnimation;

  @override
  initState() {
//    @Animation 2 --> controller 2
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
//    @Animation 2.2 --> defining what the slideAnimation is
//    @Animation Define  --> the curve animation only animate b/n 1& 0 exept when called by animmate in a detailed configration by tween
//    Tween animation will allow us to controll which values we can animate between
    _slideAnimation =
        Tween<Offset>(begin: Offset(0.0, -2.0), end: Offset(0.0, 0.0)).animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    super.initState();
  }

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
            !RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
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
//    @Animation 3 -- transition --with curved animation
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeIn),
//      @Animation 3.2 --> it refers to the slide in animation
      child: SlideTransition(

        position:_slideAnimation,
        child: TextFormField(
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
        ),
      ),
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

  void _submitForm(Function authenticate) async {
    if (!_formKey.currentState.validate() || !_formData['acceptTerms']) {
      return;
    }
    _formKey.currentState.save();
    Map<String, dynamic> succesInformation;

    succesInformation = await authenticate(
        _formData['email'], _formData['password'], _authMode);

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
//          so that when writing in the input field it would scroll up to the top
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

                  _passwordConfirmWidget(),

                  SizedBox(
                    height: 10.0,
                  ),
                  _buildAcceptSwitch(),
                  SizedBox(
                    height: 10.0,
                  ),
                  ScopedModelDescendant<MainModel>(
                    builder:
                        (BuildContext context, Widget child, MainModel model) {
//                      @CircularProgressIndicator while it is waiting to login
                      return model.isLoading
                          ? CircularProgressIndicator()
                          : RaisedButton(
                        child: Text(_authMode == AuthMode.Login
                            ? 'Login'
                            : 'Signup'),
                        onPressed: () => _submitForm(model.Authenticate),
                      );
                    },
                  ),
                  FlatButton(
                    child: Text(
                        'switch to ${_authMode == AuthMode.Login
                            ? 'Signup'
                            : "Login"}'),
                    onPressed: () {
                      if (_authMode == AuthMode.Login) {
                        setState(() {
                          _authMode = AuthMode.Signup;
                        });
//                          @Animation 4-1 -> type of animation
                        _controller.forward();
                      } else {
                        setState(() {
                          _authMode = AuthMode.Login;
                        });
//                          @Animation 4-2 -> type of animation
                        _controller.reverse();
                      }
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
