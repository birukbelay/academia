import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
//my imports
import '../../scoped_models/main_model.dart';
import '../../models/product.dart';


class ProductFab extends StatefulWidget {
  final Product product;
  ProductFab(this.product);
  @override
  _ProductFabState createState() => _ProductFabState();
}

class _ProductFabState extends State<ProductFab> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>( builder: (context, child, model){
      return  Column(
        children: <Widget>[
//          ===============  contact button ==============
          Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).cardColor,
              heroTag: 'mail',
              mini: true,
              onPressed: () async{
//                TODO check for tele & phone
                final url='mailto:${widget.product.userEmail}';
                if(await canLaunch(url)){
                  await launch(url);
                }else{
                  throw 'could not launch';
                }

              },
              child: Icon(Icons.mail),
            ),
          ),
//          ========= faavorite button ==========
          Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).cardColor,
              heroTag: 'favorite',
              mini: true,
              onPressed: (){
                model.toggleFavorite();
              },
              child: Icon(widget.product.isFavorite? Icons.favorite: Icons.favorite_border),
            ),
          ),
          Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).cardColor,
              heroTag: 'favorite',

              onPressed: (){},
              child: Icon(Icons.more_vert),
            ),
          ),
        ],
      );
    },

    );
  }
}
