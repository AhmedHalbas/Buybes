import 'package:buybes/constants.dart';
import 'package:buybes/provider/admin_mode.dart';
import 'package:buybes/provider/cart_item.dart';
import 'package:buybes/provider/modal_hud.dart';
import 'package:buybes/screens/admin/add_product.dart';
import 'package:buybes/screens/admin/admin_screen.dart';
import 'package:buybes/screens/admin/edit_product.dart';
import 'package:buybes/screens/admin/manage_products.dart';
import 'package:buybes/screens/admin/view_order_details.dart';
import 'package:buybes/screens/admin/view_orders.dart';
import 'package:buybes/screens/login_screen.dart';
import 'package:buybes/screens/signup_screen.dart';
import 'package:buybes/screens/user/cart_screen.dart';
import 'package:buybes/screens/user/home_screen.dart';
import 'package:buybes/screens/user/product_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

main() => runApp((myApp()));

class myApp extends StatelessWidget {
  bool isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          isLoggedIn = snapshot.data.getBool(kKeepMeLoggedIn) ?? false;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<ModalHud>(
                create: (context) => ModalHud(),
              ),
              ChangeNotifierProvider<AdminMode>(
                create: (context) => AdminMode(),
              ),
              ChangeNotifierProvider<CartItem>(
                create: (context) => CartItem(),
              ),
            ],
            child: MaterialApp(
              initialRoute: isLoggedIn ? HomeScreen.id : LoginScreen.id,
              routes: {
                LoginScreen.id: (context) => LoginScreen(),
                SignupScreen.id: (context) => SignupScreen(),
                HomeScreen.id: (context) => HomeScreen(),
                AdminScreen.id: (context) => AdminScreen(),
                AddProduct.id: (context) => AddProduct(),
                ManageProducts.id: (context) => ManageProducts(),
                EditProduct.id: (context) => EditProduct(),
                ViewOrders.id: (context) => ViewOrders(),
                ViewOrderDetails.id: (context) => ViewOrderDetails(),
                ProductInfo.id: (context) => ProductInfo(),
                CartScreen.id: (context) => CartScreen(),
              },
            ),
          );
        } else {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}
