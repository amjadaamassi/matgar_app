import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matgar_app/inner_screens/product_details.dart';
import 'package:matgar_app/models/favs_attr.dart';
import 'package:matgar_app/provider/cart_provider.dart';
import 'package:matgar_app/provider/dark_theme_provider.dart';
import 'package:matgar_app/services/global_method.dart';
import 'package:provider/provider.dart';





class FavoriteFull extends StatefulWidget {
  @override
  _FavoriteFullState createState() => _FavoriteFullState();
}

class _FavoriteFullState extends State<FavoriteFull> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {

    GlobalMethods globalMethods = GlobalMethods();
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final favAttrProvider = Provider.of<FavsAttr>(context);

    return InkWell(
      onTap: () => Navigator.pushNamed(context, ProductDetails.routeName,
          arguments: favAttrProvider.productId),
      child: Container(
        height: 150,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
          ),
          color: Theme.of(context).backgroundColor,
        ),
        child: Row(
          children: [
            Container(
              width: 130,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(favAttrProvider.imageUrl),
                  //  fit: BoxFit.fill,
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            favAttrProvider.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(32.0),
                            // splashColor: ,
                            onTap: () {
                              globalMethods.showDialogg(
                                  'Remove favorite!', 'favorite will be deleted!',
                                      () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await FirebaseFirestore.instance
                                        .collection('favorites')
                                        .doc(favAttrProvider.id)
                                        .delete();

                                  }, context);
                              //
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              child: _isLoading
                                  ? CircularProgressIndicator()
                                  : Icon(
                                Icons.cancel_presentation,
                                color: Colors.red,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Price:'),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${favAttrProvider.price}\$',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Quantity:'),
                        SizedBox(
                          width: 5,
                        ),

                      ],
                    ),
                    Row(
                      children: [
                        Flexible(child: Text('Order ID:')),
                        SizedBox(
                          width: 5,
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
