import 'package:flutter/material.dart';
//my imports
import 'package:academia1/widgets/ui_element/title.dart';
import './price.dart';
import 'package:academia1/models/product.dart';
import 'package:academia1/widgets/product/adress_tag.dart';

class ProductCard extends StatelessWidget {

  final Product product;
  final int index;


  ProductCard(this.product, this.index);

  Widget _buildTitlePriceRow() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TitleDefault(product.title),
          SizedBox(
            width: 8.0,
          ),
          Price(product.price.toString())
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.info),
          color: Theme.of(context).accentColor,
          onPressed: () => Navigator.pushNamed<bool>(
              context, '/product/' + index.toString()),
        ),
        IconButton(
          icon: Icon(Icons.favorite_border),
          color: Colors.red,
          onPressed: () => Navigator.pushNamed<bool>(
              context, '/product/' + index.toString()),
        )
      ],
    );
  }




  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
//                ========Image==========
          Image.asset(product.image),
//                =============Title price Widget ============
          _buildTitlePriceRow(),
          
          AddressTag("addis ababa"),
//              ==================Favorite and details =============
          _buildActionButtons(context),
        ],
      ),
    );
  }
}
