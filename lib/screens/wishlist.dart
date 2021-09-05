// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:matgar_app/inner_screens/product_details.dart';
// import 'package:matgar_app/models/favs_attr.dart';
// import 'package:matgar_app/provider/favs_provider.dart';
// import 'package:matgar_app/services/global_method.dart';
// import 'package:matgar_app/widget/wishlist_empty.dart';
// import 'package:matgar_app/widget/wishlist_full.dart';
// import 'package:provider/provider.dart';
//
//
//
//
//
//
//
// class WishlistScreen extends StatefulWidget {
//   //static const routeName = '/WishlistScreen';
//
//   @override
//   _WishlistScreenState createState() => _WishlistScreenState();
// }
//
// class _WishlistScreenState extends State<WishlistScreen> {
//
//    bool _isLoading = false;
//
//   @override
// Widget build(BuildContext context) {
//     final favAttrProvider = Provider.of<FavsAttr>(context);
//     GlobalMethods globalMethods =GlobalMethods();
//
//     final favsProvider =Provider.of<FavsProvider>(context);
//     //==========
//     return favsProvider.getFavorites.isEmpty
//         ? Scaffold(body: WishlistEmpty())
//         : Scaffold(
//             appBar: AppBar(
//               //===============
//               title: Text('Wishlist (${favsProvider.getFavorites.length})'),
//               actions: [
//                 IconButton(
//                   onPressed: () {
//                      // globalMethods.showDialogg(
//                      //              'Clear wishlist!',
//                      //              'Your wishlist will be cleared!',
//                      //              () => favsProvider
//                      //                  .clearFavs(),context);
//                     // cartProvider.clearCart();
//                   },
//                   icon: Icon(Icons.delete),
//                 )
//               ],
//             ),
//             body: ListView.builder(
//               //=============
//               itemCount: favsProvider.getFavorites.length,
//               itemBuilder: (BuildContext ctx, int index) {
//                 return InkWell(
//                   onTap: () => Navigator.pushNamed(context, ProductDetails.routeName,
//                       arguments: favAttrProvider.productId),
//                   child: Container(
//                     height: 150,
//                     margin: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         bottomRight: const Radius.circular(16.0),
//                         topRight: const Radius.circular(16.0),
//                       ),
//                       color: Theme.of(context).backgroundColor,
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 130,
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                               image: NetworkImage(favAttrProvider.imageUrl),
//                               //  fit: BoxFit.fill,
//                             ),
//                           ),
//                         ),
//                         Flexible(
//                           child: Padding(
//                             padding: const EdgeInsets.all(2.0),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Flexible(
//                                       child: Text(
//                                         favAttrProvider.title,
//                                         maxLines: 2,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w600, fontSize: 15),
//                                       ),
//                                     ),
//                                     Material(
//                                       color: Colors.transparent,
//                                       child: InkWell(
//                                         borderRadius: BorderRadius.circular(32.0),
//                                         // splashColor: ,
//                                         onTap: () {
//                                           globalMethods.showDialogg(
//                                               'Remove order!', 'Order will be deleted!',
//                                                   () async {
//                                                 setState(() {
//                                                   _isLoading = true;
//                                                 });
//                                                 await FirebaseFirestore.instance
//                                                     .collection('favorites')
//                                                     .doc(favAttrProvider.id)
//                                                     .delete();
//
//                                               }, context);
//                                           //
//                                         },
//                                         child: Container(
//                                           height: 50,
//                                           width: 50,
//                                           child: _isLoading
//                                               ? CircularProgressIndicator()
//                                               : Icon(
//                                             Icons.cancel_presentation,
//                                             color: Colors.red,
//                                             size: 22,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     Text('Price:'),
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//                                     Text(
//                                       '${favAttrProvider.price}\$',
//                                       style: TextStyle(
//                                           fontSize: 16, fontWeight: FontWeight.w600),
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     Text('Quantity:'),
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     Flexible(child: Text('Order ID:')),
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//   }
// }
//
