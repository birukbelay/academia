import 'package:flutter/material.dart';
import 'dart:math' as math;
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

class _ProductFabState extends State<ProductFab> with TickerProviderStateMixin{
  AnimationController _controller;

  @override
  void initState() {
   _controller = AnimationController(

      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Column(
          children: <Widget>[
//          ===============  contact button ==============
            Container(
              height: 70.0,
              width: 56.0,
              alignment: FractionalOffset.topCenter,
              child: ScaleTransition(
                scale: CurvedAnimation(
                    parent: _controller,
//                  this shows when the animation should start and end
                    curve: Interval(0.0, 1.0, curve: Curves.easeOut)),
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).cardColor,
                  heroTag: 'mail',
                  mini: true,
                  onPressed: () async {
//                TODO check for tele & phone
                    final url = 'mailto:${widget.product.userEmail}';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'could not launch';
                    }
                  },
                  child: Icon(Icons.mail),
                ),
              ),
            ),

//          =========------------------- faavorite button   ---------------==========
            Container(
              height: 70.0,
              width: 56.0,
              alignment: FractionalOffset.topCenter,
              child: ScaleTransition(
                scale: CurvedAnimation(
                    parent: _controller,
                    //   this shows when the animation should start and end
                    curve: Interval(0.0, 1.0, curve: Curves.easeOut)),
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).cardColor,
                  heroTag: 'favorite',
                  mini: true,
                  onPressed: () {
                    model.toggleFavorite();
                  },
                  child: Icon(widget.product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                ),
              ),
            ),

//            =====================  Toggle Button ------------===========
            Container(
              height: 70.0,
              width: 56.0,
              alignment: FractionalOffset.topCenter,
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).cardColor,
                heroTag: 'favorite',
                onPressed: () {
                  if (_controller.isDismissed) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }
                },
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform(
                      alignment: FractionalOffset.center,
                      transform: Matrix4.rotationZ(_controller.value* 0.5 * math.pi),
                        child: Icon(_controller.isDismissed? Icons.more_vert:Icons.clear));
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
