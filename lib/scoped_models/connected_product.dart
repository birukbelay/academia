import 'package:scoped_model/scoped_model.dart';

//
import '../models/user.dart';
import '../models/product.dart';

class ConnectedProducts extends Model {
  List<Product> products = [];
  User authenticatedUser;
  int selProductIndex;

  void addProduct(
      String title, String image, double price, String description) {
    final Product newProduct = new Product(
        title: title,
        image: image,
        price: price,
        description: description,
        userEmail: authenticatedUser.email,
        userId: authenticatedUser.id);
    products.add(newProduct);
    selProductIndex = null;
    notifyListeners();
  }
}
