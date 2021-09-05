import 'package:flutter/material.dart';

class FavsAttr with ChangeNotifier {
  final String id;
  final String userId;
  final String productId;
  final String title;
  final double price;
  final String imageUrl;

  FavsAttr({this.id,this.userId, this.productId, this.title, this.price, this.imageUrl});

}
