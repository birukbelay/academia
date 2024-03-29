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


  ProductCard(this.product);

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
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.info),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  model.selectProduct(product.id);
                  Navigator.pushNamed<bool>(
                    context, '/product/' + product.id).then((_){
//                      ++++ this happens when we leave the route    --------
                      model.selectProduct(null);
                  });},
              ),
              IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Colors.red,
                onPressed: () {
                  model.selectProduct(product.id);
                  model.toggleFavorite();
                },
              ),
            ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
//                ========Image==========
//        @Animation -> hero
          Hero(
            tag: product.id,
            child: FadeInImage(
              image: NetworkImage(product.image),
              height: 300.0,
              fit: BoxFit.cover,
              placeholder: AssetImage('assets/images/food/9.jpg'),
            ),
          ),
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
