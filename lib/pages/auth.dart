//import 'package:academia1/pages/product_admin.dart';
import 'package:flutter/material.dart';

//
//import 'package:academia1/pages/products_page.dart';
//import 'package:academia1/pages/product_create.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {

    return _AuthPage();
  }
}

class _AuthPage extends State<AuthPage> {
  String _email;
  String _password;

  Widget emailWidget() {
    return TextField(
      decoration: InputDecoration(
          labelText: 'E- Mail', filled: true, fillColor: Colors.white12),
      keyboardType: TextInputType.emailAddress,
      onChanged: (String value) {
        setState(() {
          _email = value;
        });
      },
    );
  }

  Widget passwordWidget() {
    return TextField(
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white12),
      obscureText: true,
      onChanged: (String value) {
        setState(() {
          _password = value;
        });
      },
    );
  }

  DecorationImage decorationImageWidget() {
    return DecorationImage(
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
        image: AssetImage('assets/images/food/34.jpg'));
  }
  Widget _appbar(){
    return AppBar(
      title: Text('auth'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:_appbar() ,

      body: Container(
        decoration: BoxDecoration(
//          decoration image
            image: decorationImageWidget()

        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                emailWidget(),
                SizedBox(
                  width: 19.0,
                ),
                passwordWidget(),

//
                RaisedButton(
                  child: Text('login'),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/admin');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
