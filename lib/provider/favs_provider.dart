import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:matgar_app/models/favs_attr.dart';
import 'package:matgar_app/models/product.dart';
import 'package:matgar_app/provider/products.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';



class FavsProvider with ChangeNotifier {

  //Map<String, FavsAttr> _favsItems = {};
  // Map<String, FavsAttr> get getFavsItems {
  //   return {..._favsItems};
  // }



  List<FavsAttr> favorites = [];

  List<FavsAttr> get getFavorites {

    return [...favorites];

  }



  // void addAndRemoveFromFav (String productId , double price , String title , String imageUrl){
  //
  //   if (_favsItems.containsKey(productId)) {
  //     removeItem(productId);
  //   } else {
  //     _favsItems.putIfAbsent(
  //         productId,
  //         () => FavsAttr(
  //             id: DateTime.now().toString(),
  //             title: title,
  //             price: price,
  //             imageUrl: imageUrl));
  //   }
  //   notifyListeners();
  // }
  // void removeItem(String productId) {
  //   _favsItems.remove(productId);
  //   notifyListeners();
  // }
  // void clearFavs() {
  //   _favsItems.clear();
  //   notifyListeners();
  // }


  Future<void> fetchFavorites() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User _user = _auth.currentUser;
    var _uid = _user.uid;

    print('the user Id is equal to $_uid');
    try {
      await FirebaseFirestore.instance
          .collection('favorites')
          .where('userId', isEqualTo: _uid)
          .get()
          .then((QuerySnapshot favoritesSnapshot) {
        favorites.clear();
        favoritesSnapshot.docs.forEach((element) {
          // print('element.get(productBrand), ${element.get('productBrand')}');
          favorites.insert(
              0,
              FavsAttr(
                // orderId: element.get('orderId'),
                // productId: element.get('productId'),
                // userId: element.get('userId'),
                // price: element.get('price').toString(),
                // quantity: element.get('quantity').toString(),
                // imageUrl: element.get('imageUrl'),
                // title: element.get('title'),
                // orderDate: element.get('orderDate'),

                id: element.get("id"),
                userId: element.get("userId"),
                productId: element.get("productId"),
                title: element.get("title"),
                price: element.get("price"),
                imageUrl: element.get("imageUrl"),


              ));
        });
      });
    } catch (error) {
      print('Printing error while fetching Favorites $error');
    }
    notifyListeners();
  }
























}
