import 'package:flutter/material.dart';

class CustomRouteFade<T> extends MaterialPageRoute<T> {
  CustomRouteFade({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if(settings.isInitialRoute){
      return child;
    }
    return FadeTransition(
        opacity: animation,
        child: child);
  }
}
//class CustomRouteSlide<T> extends MaterialPageRoute<T> {
//
//  AnimationController _controller;
//  Animation<Offset> _slideAnimation;
//
//  @override
//  initState() {
////    @Animation 2 --> controller 2
//    _controller =
//        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
////    @Animation 2.2 --> defining what the slideAnimation is
////    @Animation Define  --> the curve animation only animate b/n 1& 0 exept when called by animmate in a detailed configration by tween
////    Tween animation will allow us to controll which values we can animate between
//    _slideAnimation =
//        Tween<Offset>(begin: Offset(0.0, -2.0), end: Offset(0.0, 0.0)).animate(
//            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
//    super.initState();
//  }
//   _slideAnimation =
//  Tween<Offset>(begin: Offset(0.0, -2.0), end: Offset(0.0, 0.0)).animate(
//  CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
//  CustomRouteSlide({WidgetBuilder builder, RouteSettings settings})
//      : super(builder: builder, settings: settings);
//
//  @override
//  Widget buildTransitions(BuildContext context, Animation<double> animation,
//      Animation<double> secondaryAnimation, Widget child) {
//    if(settings.isInitialRoute){
//      return child;
//    }
//    return SlideTransition(
//
//        position: _slideAnimation,
////        Offset(0.0, -2.0), end: Offset(0.0, 0.0),
//        child: child);
//  }
//}