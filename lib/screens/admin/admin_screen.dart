import 'package:buybes/constants.dart';
import 'package:buybes/screens/admin/add_product.dart';
import 'package:buybes/screens/admin/manage_products.dart';
import 'package:buybes/screens/admin/view_orders.dart';
import 'package:buybes/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login_screen.dart';

class AdminScreen extends StatefulWidget {
  static String id = 'AdminScreen';

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final auth = Auth();
  int navBarIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) async {
          if (value == 1) {
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.clear();
            await auth.signOut();
            Navigator.popAndPushNamed(context, LoginScreen.id);
          }
          setState(() {
            navBarIndex = value;
          });
        },
        currentIndex: navBarIndex,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: kUnActiveColor,
        fixedColor: kMainColor,
        items: [
          BottomNavigationBarItem(
            title: Text(
              'Home',
              style: TextStyle(
                color: kUnActiveColor,
              ),
            ),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text(
              'Log Out',
              style: TextStyle(
                color: kUnActiveColor,
              ),
            ),
            icon: Icon(Icons.close),
          ),
        ],
      ),
      backgroundColor: kMainColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, AddProduct.id);
            },
            child: Text('Add Product'),
          ),
          SizedBox(
            height: 15,
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, ManageProducts.id);
            },
            child: Text('Edit Product'),
          ),
          SizedBox(
            height: 15,
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, ViewOrders.id);
            },
            child: Text('View Orders'),
          ),
        ],
      ),
    );
  }
}
