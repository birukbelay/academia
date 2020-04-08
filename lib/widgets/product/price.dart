import 'package:flutter/material.dart';

class Price extends StatelessWidget {
  final String price;

  Price(this.price);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(4.0)
      ),
      child: Text('\$$price',  style: TextStyle(color: Colors.white),),

    );
  }
}
