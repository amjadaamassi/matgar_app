import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:matgar_app/consts/colors.dart';
import 'package:matgar_app/models/product.dart';
import 'package:matgar_app/provider/cart_provider.dart';
import 'package:matgar_app/provider/favs_provider.dart';
import 'package:matgar_app/provider/products.dart';
import 'package:matgar_app/screens/wishlist.dart';
import 'package:matgar_app/widget/feeds_products.dart';
import 'package:provider/provider.dart';
import 'cart/cart.dart';
import 'favorite/main_favorite_screen.dart';


class Feeds extends StatefulWidget {

  static const routeName = '/Feeds';

  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {



  Future<void> _getProductsOnRefresh() async {
    await Provider.of<Products>(context, listen: false).fetchProducts();
    setState(() {});
  }




  @override
  Widget build(BuildContext context) {


    final popular = ModalRoute.of(context).settings.arguments as String;

    final productsProvider = Provider.of<Products>(context);
    List<Product> productsList = productsProvider.products;



    if (popular == 'popular') {
      productsList = productsProvider.popularProducts;
    }


    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('All Products' ,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [


          Consumer<FavsProvider>(
            builder: (_, favs, ch) => Badge(
              badgeColor: Colors.black54,
              animationType: BadgeAnimationType.slide,
              toAnimate: true,
              position: BadgePosition.topEnd(top: 5, end: 7),
              badgeContent: Text(
                //=============

                favs.getFavorites.length.toString(),
                style: TextStyle(color: Colors.white),
              ),

              child: IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(MainFavoriteScreen.routeName);
                },
              ),
            ),

          ),


          Consumer<CartProvider>(
            builder: (_, cart, ch) => Badge(
              badgeColor: Colors.black45,
              animationType: BadgeAnimationType.slide,
              toAnimate: true,
              position: BadgePosition.topEnd(top: 5, end: 7),
              badgeContent: Text(
                cart.getCartItems.length.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.amber,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
          ),


        ],
      ),
      body: RefreshIndicator(
        onRefresh: _getProductsOnRefresh,
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 240 / 450,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          children: List.generate(productsList.length, (index) {
            return ChangeNotifierProvider.value(
              value: productsList[index],
              child: FeedProducts(),
            );
          }),
        ),
      ),


    );
  }
}