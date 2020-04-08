//import 'package:flutter/material.dart';
////import 'package:map_view/map_view.dart';
//import '../helpers/ensure_visible.dart';
//
//class LocationInput extends StatefulWidget {
//  @override
//  _LocationInputState createState() => _LocationInputState();
//}
//
//class _LocationInputState extends State<LocationInput> {
//   Uri _staticMapUri;
//  final FocusNode _addressInputFocusNode=FocusNode();
//  final TextEditingController _addressInputController =TextEditingController();
//
//  @override
//  void initState() {
//    _addressInputFocusNode.addListener(_updateLocation);
//    getStaticMap(_addressInputController.text);
//    super.initState();
//  }
//
//  @override
//  void dispose(){
//    _addressInputFocusNode.removeListener(_updateLocation);
//    super.dispose();
//  }
//
//  void getStaticMap(String l) async{
//    final StaticMapProvider staticMapProvider = StaticMapProvider('AIzaSyA9kB2jWY0qBS726IxFFNheV0ylqZs-Tiw');
//    final Uri staticMapUri = staticMapProvider.getStaticUriWithMarkers([
//      Marker('position', 'position',41.40338,2.17403)
//    ], center: Location(41.40338,2.17403),
//    width:500,
//    height:300,
//    maptype:StaticMapViewType.roadmap);
//    setState((){
//      _staticMapUri = staticMapUri;
//    });
//  }
//
//  void _updateLocation(){
//if(!_addressInputFocusNode.hasFocus){
//  getStaticMap(_addressInputController.text);
//}
//  }
//  @override
//  Widget build(BuildContext context) {
//    return Column(children: <Widget>[
//      EnsureVisibleWhenFocused(
//        focusNode: _addressInputFocusNode,
//        child: TextFormField(
//        controller: _addressInputController,
//        decoration: InputDecoration(labelText:'Address'),
//      ),),
//      SizedBox(height:10.0),
//      Image.network(_staticMapUri.toString()),
//
//    ],);
//  }
//}
//
//
///// used ap