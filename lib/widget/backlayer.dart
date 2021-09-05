import 'package:flutter/material.dart';
import 'package:matgar_app/consts/colors.dart';
import '../screens/cart/cart.dart';
import 'package:matgar_app/screens/feeds.dart';



class BackLayerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
      // Container(
      //   height: double.infinity,
      //   width: double.infinity,
      //   child: Image.asset("assets/images/scrol_2.jpg" , fit: BoxFit.cover,),
      //   color: Colors.white.withOpacity(0.5),
      //
      // ),



        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                const SizedBox(height: 10.0),
                content(context, () {
                  navigateTo(context, Feeds.routeName);
                }, 'View All Products', 0),
                const SizedBox(height: 10.0),
                content(context, () {
                  navigateTo(context, CartScreen.routeName);
                }, 'Your Cart', 1),
                const SizedBox(height: 10.0),
                content(context, () {
                  navigateTo(context, Feeds.routeName);
                }, 'Your Favorites', 2),
                const SizedBox(height: 10.0),
                content(context, () {
                  navigateTo(context, Feeds.routeName);
                }, 'Upload a new product', 3),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List _contentIcons = [
    Icons.rss_feed,
   Icons.card_travel_outlined,
  Icons.favorite ,
    Icons.upload
  ];
  void navigateTo(BuildContext ctx, String routeName) {
    Navigator.of(ctx).pushNamed(
      routeName,
    );
  }

  Widget content(BuildContext ctx, Function fct, String text, int index) {
    return InkWell(
      onTap: fct,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),
          Icon(_contentIcons[index])
        ],
      ),
    );
  }
}
