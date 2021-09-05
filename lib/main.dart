import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:matgar_app/provider/orders_provider.dart';
import 'package:matgar_app/screens/favorite/main_favorite_screen.dart';
import 'package:matgar_app/screens/orders/main_order_screen.dart';
import 'package:provider/provider.dart';
import 'consts/theme_data.dart';
import 'inner_screens/brands_navigation_rail.dart';
import 'inner_screens/categories_feeds.dart';
import 'inner_screens/product_details.dart';
import 'provider/cart_provider.dart';
import 'provider/dark_theme_provider.dart';
import 'provider/favs_provider.dart';
import 'provider/products.dart';
import 'screens/auth/login.dart';
import 'screens/auth/password_forget_screen.dart';
import 'screens/auth/sign_up.dart';
import 'screens/bottom_bar.dart';
import 'screens/cart/cart.dart';
import 'screens/feeds.dart';
import 'screens/landing_page.dart';
import 'screens/upload_product_screen.dart';
import 'screens/user_state.dart';
import 'screens/wishlist.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    print('called ,mmmmm');
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text('Error occured'),
                ),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return themeChangeProvider;
              }),
              ChangeNotifierProvider(
                create: (_) => Products(),
              ),
              ChangeNotifierProvider(
                create: (_) => CartProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => FavsProvider(),
              ),
               ChangeNotifierProvider(
                 create: (_) => OrdersProvider(),
               ),
            ],
            child: Consumer<DarkThemeProvider>(
              builder: (context, themeChangeProvider, ch) {
                return MaterialApp(
                  title: 'Flutter Shop',
                  theme:
                  Styles.themeData(themeChangeProvider.darkTheme, context),
                  home: UserState(),
                 // UserState(),

                  routes: {
                    BrandNavigationRailScreen.routeName: (ctx) =>  BrandNavigationRailScreen(),
                    CartScreen.routeName: (ctx) => CartScreen(),
                    Feeds.routeName: (ctx) => Feeds(),
                    MainFavoriteScreen.routeName: (ctx) => MainFavoriteScreen(),
                    ProductDetails.routeName: (ctx) => ProductDetails(),
                    CategoriesFeedsScreen.routeName: (ctx) =>CategoriesFeedsScreen(),
                    LoginScreen.routeName: (ctx) => LoginScreen(),
                    SignUpScreen.routeName: (ctx) => SignUpScreen(),
                    BottomBarScreen.routeName: (ctx) => BottomBarScreen(),

                    UploadProductForm.routeName: (ctx) => UploadProductForm(),
                    ForgetPassword.routeName: (ctx) => ForgetPassword(),
                     OrderScreen.routeName: (ctx) => OrderScreen(),
                  },
                );
              },
            ),
          );
        });
  }
}