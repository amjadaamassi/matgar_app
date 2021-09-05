import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:matgar_app/models/cart_attr.dart';



class CartProvider with ChangeNotifier {
  //Map<String, CartAttr> _cartItems = {};

//  Map<String, CartAttr> get getCartItems {
//    return {..._cartItems};
//  }

  CartAttr _cartAttr;
  List<CartAttr> _carts = [];


  List<CartAttr> get getCartItems {
    return [..._carts];
  }


  double get totalAmount {
    var total = 0.0;
    _carts.forEach((value) {
      total += value.price * value.quantity;
    });
    return total;
  }





//  void addProductToCart( String productId, double price, String title, String imageUrl) {
//
//    if (_cartItems.containsKey(productId)) {
//      _cartItems.update(
//          productId,
//              (exitingCartItem) => CartAttr(
//              id: exitingCartItem.id,
//              productId: exitingCartItem.productId,
//              title: exitingCartItem.title,
//              price: exitingCartItem.price,
//              quantity: exitingCartItem.quantity + 1,
//              imageUrl: exitingCartItem.imageUrl)
//      );
//    } else {
//      _cartItems.putIfAbsent(
//          productId,
//              () => CartAttr(
//              id: DateTime.now().toString(),
//              productId: productId,
//              title: title,
//              price: price,
//              quantity: 1,
//              imageUrl: imageUrl));
//    }
//    notifyListeners();
//  }




  Future<void> fetchCarts() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User _user = _auth.currentUser;
    var _uid = _user.uid;

    print('the user Id is equal to $_uid');
    try {
      await FirebaseFirestore.instance
          .collection('cart')
          .where('userId', isEqualTo: _uid)
          .get()
          .then((QuerySnapshot favoritesSnapshot) {
        _carts.clear();
        favoritesSnapshot.docs.forEach((element) {
          // print('element.get(productBrand), ${element.get('productBrand')}');
          _carts.insert(
              0,
              CartAttr(
                id: element.get("id"),
                userId: element.get("userId"),
                productId: element.get("productId"),
                title: element.get("title"),
                quantity: element.get("quantity") + 1,
                price: element.get("price"),
                imageUrl: element.get("imageUrl"),
              ));
        });
      });
    } catch (error) {
      print('Printing error while fetching carts $error');
    }
    notifyListeners();
  }


  Future<void> reduceItemByOne() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User _user = _auth.currentUser;
    var _uid = _user.uid;
    print('the user Id is equal to $_uid');
    try {
      await FirebaseFirestore.instance
          .collection('cart')
          .where('userId', isEqualTo: _uid)
          .get()
          .then((QuerySnapshot favoritesSnapshot) {
        _carts.clear();
        favoritesSnapshot.docs.forEach((element) {
          // print('element.get(productBrand), ${element.get('pr
          _carts.insert(
              0,
              CartAttr(
                id: element.get("id"),
                userId: element.get("userId"),
                productId: element.get("productId"),
                title: element.get("title"),
                quantity: element.get("quantity") - 1,
                price: element.get("price"),
                imageUrl: element.get("imageUrl"),
              ));
        });
      });
    } catch (error) {
      print('Printing error while fetching carts $error');
    }
    notifyListeners();
  }










// void reduceItemByOne(String productId) {
//   if (_carts.contains(productId)) {
//     _carts.indexWhere((element) => element.id == productId );
//       CartAttr(
//            id: _cartAttr.id ,
//            userId: _cartAttr.userId,
//            productId: _cartAttr.productId,
//            title: _cartAttr.productId,
//           quantity: _cartAttr.quantity - 1,
//           price: _cartAttr.price,
//            imageUrl: _cartAttr.imageUrl);
//
//   }
//   notifyListeners();
// }
//









  void removeItem(String productId) {
    _carts.remove(productId);
    notifyListeners();
  }



  void clearCart() {
    _carts.clear();
    notifyListeners();
  }
}