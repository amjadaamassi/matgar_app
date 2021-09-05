import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matgar_app/consts/colors.dart';
import 'package:matgar_app/inner_screens/product_details.dart';
import 'package:matgar_app/provider/cart_provider.dart';
import 'package:matgar_app/provider/dark_theme_provider.dart';
import 'package:matgar_app/provider/favs_provider.dart';
import 'package:matgar_app/provider/products.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FeedDialog extends StatefulWidget {
  final String productId;

  const FeedDialog({@required this.productId});

  @override
  _FeedDialogState createState() => _FeedDialogState();
}

class _FeedDialogState extends State<FeedDialog> {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: false);

    final cartProvider = Provider.of<CartProvider>(context);

    final favsProvider = Provider.of<FavsProvider>(context);

    final prodAttr = productsData.findById(widget.productId);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Column(children: [
          Container(
            constraints: BoxConstraints(
                minHeight: 100,
                maxHeight: MediaQuery.of(context).size.height * 0.5),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Image.network(
              prodAttr.imageUrl,
            ),
          ),
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: dialogContent(
                        context,
                        0,
                        () async => {
                          setFavorite(context),
                              Navigator.canPop(context)
                                  ? Navigator.pop(context)
                                  : null,
                            }),
                  ),

                  Flexible(
                    child: dialogContent(
                        context,
                        1,
                        () => {
                              Navigator.pushNamed(
                                      context, ProductDetails.routeName,
                                      arguments: prodAttr.id)
                                  .then((value) => Navigator.canPop(context)
                                      ? Navigator.pop(context)
                                      : null),
                            }),
                  ),
                  Flexible(
                    child: dialogContent(
                      context,
                      2,
                      () async => {
                              setCartItems(context),
                              Navigator.canPop(context)
                              ? Navigator.pop(context)
                                  : null,
                              }

                    ),
                  ),
                ]),
          ),

          /************close****************/
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.3),
                shape: BoxShape.circle),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                splashColor: Colors.grey,
                onTap: () =>
                    Navigator.canPop(context) ? Navigator.pop(context) : null,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.close, size: 28, color: Colors.white),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget dialogContent(BuildContext context, int index, Function fct) {
    final cart = Provider.of<CartProvider>(context);

    final favs = Provider.of<FavsProvider>(context);

    List<IconData> _dialogIcons = [
      favs.getFavorites.contains(widget.productId)
          ? Icons.favorite
          : Icons.favorite_border,
      Icons.remove_red_eye,
      Icons.shopping_cart,
    ];

    List<String> _texts = [
      favs.favorites.contains(widget.productId)
          ? 'In wishlist'
          : 'Add to wishlist',
      'View product',
      cart.getCartItems.contains(widget.productId) ? 'In Cart ' : 'Add to cart',
    ];
    setState(() {

    });
    List<Color> _colors = [
      favs.favorites.contains(widget.productId)
          ? Colors.red
          : Theme.of(context).textSelectionColor,
      Theme.of(context).textSelectionColor,
      Theme.of(context).textSelectionColor,
    ];
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return FittedBox(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: fct,
          splashColor: Colors.grey,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.25,
            padding: EdgeInsets.all(4),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    // inkwell color
                    child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(
                          _dialogIcons[index],
                          color: _colors[index],
                          size: 25,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(
                    child: Text(
                      _texts[index],
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        //  fontSize: 15,
                        color: themeChange.darkTheme
                            ? Theme.of(context).disabledColor
                            : ColorsConsts.subTitle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> setFavorite(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var uuid = Uuid();
    final FavId = uuid.v4();
    User user = _auth.currentUser;
    final _uid = user.uid;
    final productsData = Provider.of<Products>(context, listen: false);

    final prodAttr = productsData.findById(widget.productId);

    await FirebaseFirestore.instance
        .collection('favorites')
        .doc(FavId)
        .set({
      'id': FavId,
      'userId': _uid,
      'productId': prodAttr.id,
      'title': prodAttr.title,
      'price': prodAttr.price,
      'imageUrl': prodAttr.imageUrl,
    });
    setState(() {
    });
  }

  Future<void> setCartItems(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var uuid = Uuid();
    final cartId = uuid.v4();
    User user = _auth.currentUser;
    final _uid = user.uid;
    final productsData = Provider.of<Products>(context, listen: false);

    final prodAttr = productsData.findById(widget.productId);

    await FirebaseFirestore.instance
        .collection('cart')
        .doc(cartId)
        .set({
      'id': cartId,
      'userId': _uid,
      'productId': prodAttr.id,
      'title': prodAttr.title,
      "quantity": 0 ,
      'price': prodAttr.price,
      'imageUrl': prodAttr.imageUrl,
    });

  }
}



