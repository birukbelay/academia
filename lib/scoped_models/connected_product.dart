import 'package:scoped_model/scoped_model.dart';

//
import '../models/user.dart';
import '../models/product.dart';

class ConnectedProducts extends Model {
  List<Product> _products = [];
  User _authenticatedUser;
  int _selProductIndex;

  void addProduct(
      String title, String image, double price, String description) {
    final Product newProduct = new Product(
        title: title,
        image: image,
        price: price,
        description: description,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id);
    _products.add(newProduct);
    _selProductIndex = null;
    notifyListeners();
  }
}

//===========================  user model class ======================
mixin UserModel on ConnectedProducts {
  void login(String email, String password) {
    _authenticatedUser = User(id: 'q123', email: email, password: password);
  }
}
//===========================product model class ===============================

mixin ProductsModel on ConnectedProducts {
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _selProductIndex;
  }

  Product get selectedProduct {
    if (selectedProductIndex == null) {
      return null;
    }
    return _products[selectedProductIndex];
  }

  bool get displayFavOnly {
    return _showFavorites;
  }

  void updateProduct(
      String title, String image, double price, String description) {
    final Product updatedProduct = new Product(
        title: title,
        image: image,
        price: price,
        description: description,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    _products[selectedProductIndex] = updatedProduct;
    _selProductIndex = null;
  }

  void deleteProduct() {
    _products.removeAt(selectedProductIndex);
    _selProductIndex = null;
    notifyListeners();
  }

  void toggleFavorite() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
      title: selectedProduct.title,
      description: selectedProduct.description,
      image: selectedProduct.image,
      userId: selectedProduct.userId,
      userEmail: selectedProduct.userEmail,
      price: selectedProduct.price,
      isFavorite: newFavStatus,
    );
    _products[selectedProductIndex] = updatedProduct;
    _selProductIndex = null;
    notifyListeners();
  }

  void selectProduct(int index) {
    _selProductIndex = index;
  }

  void toggleDisplayFavorites() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}
