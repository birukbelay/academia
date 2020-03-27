
//
import '../models/user.dart';
import './connected_product.dart';

mixin UserModel on ConnectedProducts{


  void login(String email, String password){
    authenticatedUser = User(id: 'q123', email: email, password: password);
  }
}