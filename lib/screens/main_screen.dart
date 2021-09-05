import 'package:flutter/material.dart';
import 'package:matgar_app/screens/upload_product_screen.dart';

import 'bottom_bar.dart';



class MainScreens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [BottomBarScreen(), UploadProductForm()],
    );
  }
}