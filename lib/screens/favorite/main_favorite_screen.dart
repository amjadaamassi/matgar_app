import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matgar_app/provider/favs_provider.dart';
import 'package:matgar_app/services/global_method.dart';
import 'package:provider/provider.dart';

import 'empty_favorite_screen.dart';
import 'full_favorite_screen.dart';


class MainFavoriteScreen extends StatefulWidget {
  static const routeName = '/favoriteScreen';

  @override
  _MainFavoriteScreenState createState() => _MainFavoriteScreenState();
}

class _MainFavoriteScreenState extends State<MainFavoriteScreen> {

  @override
  Widget build(BuildContext context) {
    GlobalMethods globalMethods = GlobalMethods();
    final favsProvider = Provider.of<FavsProvider>(context);
    return FutureBuilder(
        future: favsProvider.fetchFavorites(),
        builder: (context, snapshot) {
          return favsProvider.getFavorites.isEmpty
              ? Scaffold(body: FavoriteEmpty())

              : Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).backgroundColor,
               // title: Text('Orders (${orderProvider.getOrders.length})'),
                actions: [
                  IconButton(
                    onPressed: ()  {
                      globalMethods.showDialogg(
                          'Clear favorites!',
                          'Your favorites will be cleared!',
                              () async {
                            final FirebaseAuth _auth = FirebaseAuth.instance;
                            User _user = _auth.currentUser;
                            var _uid = _user.uid;

                            await FirebaseFirestore.instance
                                .collection('favorites').where('userId', isEqualTo: _uid).get().then((value) => value.docs.forEach((element) {

                              element.reference.delete();
                            }));



                          },

                          context);
                    },
                    icon: Icon(Icons.delete_outline),
                  )
                ],
              ),
              body: Container(
                margin: EdgeInsets.only(bottom: 60),
                child: ListView.builder(
                    itemCount: favsProvider.getFavorites.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return ChangeNotifierProvider.value(
                          value: favsProvider.getFavorites[index],
                          child: FavoriteFull());
                    }),
              ));
        });
  }
}



//      cartProvider.getCartItems.isEmpty
//        ? Scaffold(body: CartEmpty() , backgroundColor: Colors.white,)
//        : Scaffold(
//      bottomSheet: checkoutSection(context, cartProvider.totalAmount),
//      appBar: AppBar(
//        backgroundColor: Theme.of(context).backgroundColor,
//        title: Text('Cart (${cartProvider.getCartItems.length})'),
//        actions: [
//          IconButton(
//            onPressed: () {
//              globalMethods.showDialogg(
//                  'Clear cart!',
//                  'Your cart will be cleared!',
//                      () => cartProvider.clearCart(),
//                  context);
//              // cartProvider.clearCart();
//            },
//            icon: Icon(Icons.delete_outline),
//          )
//        ],
//      ),
//      body: Container(
//        margin: EdgeInsets.only(bottom: 60),
//        child: ListView.builder(
//            itemCount: cartProvider.getCartItems.length,
//            itemBuilder: (BuildContext ctx, int index) {
//              return ChangeNotifierProvider.value(
//                value: cartProvider.getCartItems[index],
//                child: CartFull(),
//                 // productId:
//                 // cartProvider.getCartItems.keys.toList()[index],
//                  // id:  cartProvider.getCartItems.values.toList()[index].id,
//                  // productId: cartProvider.getCartItems.keys.toList()[index],
//                  // price: cartProvider.getCartItems.values.toList()[index].price,
//                  // title: cartProvider.getCartItems.values.toList()[index].title,
//                  // imageUrl: cartProvider.getCartItems.values.toList()[index].imageUrl,
//                  // quatity: cartProvider.getCartItems.values.toList()[index].quantity,
//
//              );
//            }),
//      ),
//    );




