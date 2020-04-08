import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';

//
import '../models/user.dart';
import '../models/product.dart';
import '../models/auth.dart';

class ConnectedProducts extends Model {
  List<Product> _products = [];
  List<Product> _myProducts = [];
  User _authenticatedUser;
  String _selProductId;
  bool _isLoading = false;
  bool _isAuthenticated = false;

//  Links for web

  //FIXME i dont know making these have a problem
  static String _dbUrl = 'https://academia-4afa1.firebaseio.com/';
  String _productUrl = _dbUrl + '/products';
  static String apiKey="AIzaSyC00tSqK0IIKP6WtDVssHa_X3g0XfrSfwQ";
  String  signupAuthUrl = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey';
  String signinAuthUrl = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey';
  var mapApiKey ="AIzaSyA9kB2jWY0qBS726IxFFNheV0ylqZs-Tiw";

  String staticImage =
       'https://m.media-amazon.com/images/S/aplus-media/vc/7ee7f4e8-31f9-475e-b2b4-dbf30c1f0f11._CR189,0,1814,1814_PT0_SX300__.jpg';
}

//######================== product model mixin ==================

mixin ProductsModel on ConnectedProducts {
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get myProducts {
    return List.from(_myProducts);
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

  // -------------------========= 1 fetchProducts ========--------------

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();

    return http
        .get(_productUrl + '.json')
        .then<Null>((http.Response response) {
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
            userId: productData['userId'],
//            TODO may be to compare this field to the one in the users fav list
            isFavorite: productData['wishlistUsers'] == null
                ? false
                : (productData['wishlistUsers'] as Map<String, dynamic>)
                .containsKey(_authenticatedUser.id)
        );
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




  // -------------------========= 2 fetchMyProducts ========--------------

  Future<Null> fetchMyProducts() {
    _isLoading = true;
    notifyListeners();

    return http
//    TODO make a function that fetches the users only products
        .get(_productUrl + '.json')
        .then<Null>((http.Response response) {
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
            userId: productData['userId'],
//            TODO may be to compare this field to the one i the users fav list
            isFavorite: productData['wishlistUsers'] == null
                ? false
                : (productData['wishlistUsers'] as Map<String, dynamic>)
                .containsKey(_authenticatedUser.id)
        );
        fetchedProductsList.add(product);
      });

      _myProducts = fetchedProductsList;
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
    }).catchError((e) {
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
      print("#####error...: $e");
      return false;
    });
  } //fetch products









  //  =--------------------=========   3 add product ==------------------------=

  Future<bool> addProduct(String title, String image, double price,
      String description) async {
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
      final http.Response response = await http.post(
          _productUrl + '.json?auth=${_authenticatedUser.token}',
          body: json.encode(productData));

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
      _myProducts.add(newProduct);
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

//  ---------------------==== 4 updateProduct ====---------------------

  Future<bool> updateProduct(String title, String image, double price,
      String description) {
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
        .put(
        _productUrl +
            '/${selectedProduct.id}.json?auth=${_authenticatedUser.token}',
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

//--------------------=== 5  delete product ======-----------
  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    return http
        .delete(
        _productUrl + '/$deletedId.json?auth=${_authenticatedUser.token}')
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

//  ---------------  ======= 6 favToggle =====--------

  void toggleFavorite() async {
    String favUrl = '$_productUrl/${selectedProduct
        .id}/wishlistUsers/${_authenticatedUser
        .id}.json?auth=${_authenticatedUser.token}';

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

//    TODO putting to the users own favorite list && search for which is a better design
    http.Response response;
    if (newFavStatus) {
      response = await http.put(favUrl, body: json.encode(true));
    } else {
      response = await http.delete(favUrl);
    }


    if (response.statusCode != 200 && response.statusCode != 201) {
      final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        image: selectedProduct.image,
        userId: selectedProduct.userId,
        userEmail: selectedProduct.userEmail,
        price: selectedProduct.price,
        isFavorite: !newFavStatus,
      );
      _products[selectedProductIndex] = updatedProduct;
//    _selProductIndex = null;
      notifyListeners();
    }
  }

  void toggleDisplayFavorites() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

//#####===========================  user model mixin ======================

mixin UserModel on ConnectedProducts {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  User get user {
    return _authenticatedUser;
  }

  bool get isAuthenticated {
    return _isAuthenticated;
  }

  PublishSubject<bool> get userSubect {
    return _userSubject;
  }

//  ----------------===== Authenticate ========----------

  Future<Map<String, dynamic>> Authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    http.Response response;
    if (mode == AuthMode.Login) {

      //TODO | Auth  backend needs to be set up
      //TODO | u must handle the response from the database

      response = await http.post( signinAuthUrl,
          body: json.encode(authData),
          headers: {'Content-type': 'application/json'});
    } else {
      response = await http.post(signupAuthUrl,
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    }
//---------------  responseData  is parsed from response
    final Map<String, dynamic> responseData = json.decode(response.body);

    bool hasError = true;
    String message = 'something went wrong';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication sucess';
      _authenticatedUser = User(
          id: responseData['uid'],
          email: responseData['email'],
          token: responseData['idToken']);

//      TODO  EXPIRESIN IS A RESPONSE FROM THE FIRE
      setAuthTimeout(int.parse(responseData['expiresIn']));
      _userSubject.add(true);

      final DateTime now = DateTime.now();
      final DateTime expiryTime =
      now.add(Duration(seconds: int.parse(responseData['expiresIn'])));

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('email', email);
      prefs.setString('userId', responseData['localId']);
      prefs.setString('expiryTime', expiryTime.toIso8601String());

      _isAuthenticated = true;
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'EMAIL OR PASSWORD WRONG';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'EMAIL OR PASSWORD WRONG';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'this email alreaady exists';
    }

    print(response);
//    _isauthenticated = true;
    _isLoading = false;
    notifyListeners();

//    @@@ CHANGED TO !HASERROR so that it will be fine in teh product edit page
    return {'sucess': !hasError, 'message': message};
  }

//  =========== ---------- autho authenticate --------- =======

  void autoAuthenticate() async {

//    getting the token from SharedPreferences and parsing the time
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTime = prefs.getString('expiryTime');
    final parsedExpiryTime = DateTime.parse(expiryTime);

    if (token != null) {
      final DateTime now = DateTime.parse(expiryTime);
      if (parsedExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners();
        return;
      }
      final String email = prefs.getString('email');
      final String userId = prefs.getString('userId');
      final int tokenLifespan = parsedExpiryTime
          .difference(now)
          .inSeconds;
      _userSubject.add(true);

      setAuthTimeout(tokenLifespan);
      _authenticatedUser = User(id: userId, email: email, token: token);
      notifyListeners();
    }
  }

  void logout() async {
    _authenticatedUser = null;
    _authTimer.cancel();
    //    this emmiting an event
    _userSubject.add(false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('email');
    prefs.remove('userId');
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);

    //    this emmiting an event
    _userSubject.add(false);
  }
}

//========================== model utility ====================
mixin UtilityModel on ConnectedProducts {
  bool get isLoading {
    return _isLoading;
  }
}
