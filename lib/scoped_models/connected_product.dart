import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//
import '../models/user.dart';
import '../models/product.dart';

class ConnectedProducts extends Model {
  List<Product> _products = [];
  User _authenticatedUser;
  String _selProductId;
  bool _isLoading = false;
  bool _isauthenticated = false;

  static String _dbUrl = 'https://academia-4afa1.firebaseio.com/';
  String _productUrl = _dbUrl + 'products';
  String staticImage =
      'https://m.media-amazon.com/images/S/aplus-media/vc/7ee7f4e8-31f9-475e-b2b4-dbf30c1f0f11._CR189,0,1814,1814_PT0_SX300__.jpg';


}

//######================== product model mixin ==================

mixin ProductsModel on ConnectedProducts {
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedFavoriteProducts {
    if (_showFavorites) {
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _products.indexWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  String get selectedProductId {
    return _selProductId;
  }

  void selectProduct(String productId) {
    _selProductId = productId;
  }

  Product get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }
    return _products.firstWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  bool get displayFavOnly {
    return _showFavorites;
  }

  // -------------------=========1 fetchProducts ========--------------
  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();

    return http.get(_productUrl + '.json').then<Null>((http.Response response) {
      print(response.body);
      final List<Product> fetchedProductsList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);

      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      productListData.forEach((String productId, dynamic productData) {
        final Product product = Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            image: productData['image'],
            price: productData['price'],
            userEmail: productData['userEmail'],
            userId: productData['userId']);
        fetchedProductsList.add(product);
      });

      _products = fetchedProductsList;
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
    }).catchError((e) {
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
      print("error...: $e");
      return false;
    });
  } //fetch products

  //  ===================   add product ===============

  Future<bool> addProduct(
      String title, String image, double price, String description) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image': staticImage,
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };

    try {
      final http.Response response =
      await http.post(_productUrl, body: json.encode(productData));

      if (response.statusCode != 200 || response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      final Product newProduct = new Product(
          id: responseData['name'],
          title: title,
          image: image,
          price: price,
          description: description,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);

      _products.add(newProduct);
      _selProductId = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print("error...: $e");
      return false;
    }
  }

//  ---------------------====2 updateProduct ====---------------------

  Future<bool> updateProduct(
      String title, String image, double price, String description) {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'image': staticImage,
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };

    return http
        .put(_productUrl + '/${selectedProduct.id}.json',
            body: json.encode(updateData))
        .then((http.Response response) {
      _isLoading = false;

      final Product updatedProduct = new Product(
          id: selectedProduct.id,
          title: title,
          image: image,
          price: price,
          description: description,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
      return true;
//      _selProductIndex = null;
    }).catchError((e) {
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
      print("error...: $e");
      return false;
    });
  }

//--------------------===3  delete product ======-----------
  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    return http
        .delete(_productUrl + '/$deletedId.json')
        .then((http.Response response) {

      _products.removeAt(selectedProductIndex);
      _isLoading = false;
      notifyListeners();
//      _selProductIndex = null;
      return true;
    }).catchError((e) {
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
      print("error...: $e");
      return false;
    });
  }

//  ---------------  =======4 favToggle =====--------

  void toggleFavorite() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavStatus = !isCurrentlyFavorite;

    final Product updatedProduct = Product(
      id: selectedProduct.id,
      title: selectedProduct.title,
      description: selectedProduct.description,
      image: selectedProduct.image,
      userId: selectedProduct.userId,
      userEmail: selectedProduct.userEmail,
      price: selectedProduct.price,
      isFavorite: newFavStatus,
    );
    _products[selectedProductIndex] = updatedProduct;
//    _selProductIndex = null;
    notifyListeners();
  }

  void toggleDisplayFavorites() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

//#####===========================  user model mixin ======================

mixin UserModel on ConnectedProducts {

//  ----------------===== Login ========----------

  Future<Map<String, dynamic>> login(String email, String password) async{
    _isLoading=true;
    notifyListeners();
    final Map<String, dynamic> authData ={
      'email':email,
      'password':password,
      'returnSecureToken':true
    };
//    TODO  Login  backend needs to be set up
    final http.Response response =await http.post('https:the uri?key=kldkflkjkj',body: json.encode(authData),
    headers: {'Content-type': 'application/json'});
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError =true;
    String message = 'something went wrong';
    if(responseData.containsKey('idToken')){
      hasError=false;
      message ='Authentication sucess';

    }else if(responseData['error']['message']=='EMAIL_NOT_FOUND'){
      message='EMAIL OR PASSWORD WRONG';
    }
    else if(responseData['error']['message']=='INVALID_PASSWORD'){
      message='EMAIL OR PASSWORD WRONG';
    }

    print(response);
    _isauthenticated = true;
    _isLoading=false;
    notifyListeners();

//    @@@ CHANGED TO !HASERROR so that it will be fine in teh product edit page
    return{'sucess': !hasError, 'message':message};


//    _authenticatedUser = User(id: 'q123', email: email, password: password);
//  _isauthenticated = true;

}

  bool get isAuthenticated {
    return _isauthenticated;
  }

//  =========--------signup------============

  Future<Map<String, dynamic>> signup(String email, String password) async{
    _isLoading=true;
    notifyListeners();
    final Map<String, dynamic> authData ={
      'email':email,
      'password':password,
      'returnSecureToken':true
    };
    //  TODO SignUp back end not setup
    final http.Response response =await http.post('https:my url with secure api',
          body: json.encode(authData),
      headers: {'Content-Type':'application/json'}
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError =true;
    String message = 'something went wrong';
    if(responseData.containsKey('idToken')){
      hasError=false;
      message ='Authentication sucess';

    }else if(responseData['error']['message']=='EMAIL_EXISTS'){
      message='this email alreaady exists';
    }

    print(response);
    _isauthenticated = true;
    _isLoading=true;
    notifyListeners();
//    @@@ CHANGED TO !HASERROR so that it will be fine in teh product edit page
    return{'sucess': !hasError, 'message':message};

  }
}

//========================== model utility ====================
mixin UtilityModel on ConnectedProducts {
  bool get isLoading {
    return _isLoading;
  }
}
