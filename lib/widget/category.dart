import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matgar_app/inner_screens/categories_feeds.dart';




class CategoryWidget extends StatefulWidget {
  CategoryWidget({ this.index});
  final int index;

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {



  List<Map<String, Object>> categories = [


    {
      'categoryName': 'Phones',
      'categoryImagesPath': 'assets/images/phone_1.jpg',
    },

    {
      'categoryName': 'Clothes',
      'categoryImagesPath': 'assets/images/clothes.jpg',
    },

    {
      'categoryName': 'Shoes',
      'categoryImagesPath': 'assets/images/shose_1.jpg',
    },

    {
      'categoryName': 'Beauty&Health',
      'categoryImagesPath': 'assets/images/helth_2.jpg',
    },

    {
      'categoryName': 'Laptops',
      'categoryImagesPath': 'assets/images/laptop_1.jpg',
    },

    {
      'categoryName': 'Furniture',
      'categoryImagesPath': 'assets/images/Furniture.jpg',
    },

    {
      'categoryName': 'Watches',
      'categoryImagesPath': 'assets/images/watches_1.jpg',
    },


  ];



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: (){
      Navigator.of(context).pushNamed(CategoriesFeedsScreen.routeName, arguments: '${categories[widget.index]['categoryName']}');

          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              image: DecorationImage(
                image: AssetImage(categories[widget.index]['categoryImagesPath']),
              fit: BoxFit.cover,
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: 150,
            height: 150,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 10,
          right: 10,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            color: Colors.black54,
            child: Text(
              categories[widget.index]['categoryName'],
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
