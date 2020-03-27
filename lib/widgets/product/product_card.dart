import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
//my imports
import '../../widgets/ui_element/title.dart';
import './price.dart';
import '../../models/product.dart';
import '../../widgets/product/adress_tag.dart';
import '../../scoped_models/main_model.dart';


class ProductCard extends StatelessWidget {

  final Product product;
  final int productIndex;


  ProductCard(this.product, this.productIndex);

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
              context, '/product/' + productIndex.toString()),
        ),
        ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
         return IconButton(
            icon: Icon(model.products[productIndex].isFavorite?Icons.favorite : Icons.favorite_border),
            color: Colors.red,
            onPressed: () {
                model.selectProduct(productIndex);
                model.toggleFavorite();

            },
          );
        },

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
