import 'package:backdrop/app_bar.dart';
import 'package:backdrop/button.dart';
import 'package:backdrop/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:matgar_app/consts/colors.dart';
import 'package:matgar_app/inner_screens/brands_navigation_rail.dart';
import 'package:matgar_app/provider/products.dart';
import 'package:matgar_app/widget/backlayer.dart';
import 'package:matgar_app/widget/category.dart';
import 'package:matgar_app/widget/popular_products.dart';
import 'package:provider/provider.dart';
import 'feeds.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {



  List _carouselImages = [
    'assets/images/scrol_1.jpg',
    'assets/images/scrol_6.jpg',
    'assets/images/scrol_3.jpg',
    'assets/images/scrol_4.jpg',
    'assets/images/scrol_5.jpg',
  ];





  List _brandImages = [
    'assets/images/addidas_logo1.jpg',
    'assets/images/apple_logo.jpg',
    'assets/images/dell_logo.jpg',
    'assets/images/huawei_logo.jpg',
    'assets/images/nike_logo.jpg',
    'assets/images/samsung_logo.gif',
    'assets/images/h&m_logo.jpg',
  ];



  @override
  Widget build(BuildContext context) {


    final productsData = Provider.of<Products>(context);
    productsData.fetchProducts();

    final popularItems = productsData.popularProducts;



    return Scaffold(
      backgroundColor: Colors.white,
      body: BackdropScaffold(
        backgroundColor: Colors.white,

        frontLayerBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        headerHeight: MediaQuery.of(context).size.height * 0.30,
        appBar: BackdropAppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Text("Home" ,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: BackdropToggleButton(icon: AnimatedIcons.home_menu , color: Colors.black,),
          // flexibleSpace: Container(
          //   decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //     colors: [
          //     ColorsConsts.starterColor,
          //     ColorsConsts.endColor
          //   ])),
          // ),
          actions: <Widget>[
            IconButton(
              iconSize: 15,
              padding: const EdgeInsets.all(10),
              icon: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 13,
                  backgroundImage: NetworkImage(
                      'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg'),
                ),
              ),
              onPressed: () {},
            )
          ],
        ),
        backLayer: BackLayerMenu(),
        frontLayer: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                height: 250.0,
                width: double.infinity,
                child: Carousel(
                  boxFit: BoxFit.fill,
                  autoplay: true,
                  animationCurve: Curves.fastOutSlowIn,
                  animationDuration: Duration(milliseconds: 1000),
                  dotSize: 5.0,
                  dotIncreasedColor: Colors.black54,
                 // dotBgColor: Colors.black.withOpacity(0.2),
                  dotPosition: DotPosition.bottomCenter,
                  showIndicator: true,
                  indicatorBgPadding: 10.0,
                  images: [
                    ExactAssetImage(_carouselImages[0]),
                    ExactAssetImage(_carouselImages[1]),
                    ExactAssetImage(_carouselImages[2]),
                    ExactAssetImage(_carouselImages[3]),
                    ExactAssetImage(_carouselImages[4]),
                  ],
                ),
              ),










            // Categories =========================================================================================
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Categories',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
              Container(
                width: double.infinity,
                height: 180,
                child: ListView.builder(
                  itemCount: 7,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext ctx, int index) {
                    return CategoryWidget(
                      index: index,
                    );
                  },
                ),
              ),


































              //Brands ==================================================================================
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Popular Brands',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                    ),
                    Spacer(),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          BrandNavigationRailScreen.routeName,
                          arguments: {
                            7,
                          },
                        );
                      },
                      child: Text(
                        'View all...',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                height: 210,
                width: MediaQuery.of(context).size.width * 0.95,
                child: Swiper(
                  itemCount: _brandImages.length,
                  autoplay: true,
                  viewportFraction: 0.75,
                  scale: 0.9,
                  onTap: (index) {
                    Navigator.of(context).pushNamed(
                      BrandNavigationRailScreen.routeName,
                      arguments: {
                        index,
                      },
                    );
                  },
                  itemBuilder: (BuildContext ctx, int index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.blueGrey,
                        child: Image.asset(
                          _brandImages[index],
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  },
                ),
              ),



              //Popular Products ==================================================================================================

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Popular Products',
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                    Spacer(),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(Feeds.routeName, arguments: 'popular');
                      },
                      child: Text(
                        'View all...',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: Colors.red),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 285,
                margin: EdgeInsets.symmetric(horizontal: 3),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: popularItems.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return ChangeNotifierProvider.value(
                        value: popularItems[index],
                        child: PopularProducts(
                            // imageUrl: popularItems[index].imageUrl,
                            // title: popularItems[index].title,
                            // description: popularItems[index].description,
                            // price: popularItems[index].price,
                            ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
