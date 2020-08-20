import 'package:buybes/constants.dart';
import 'package:buybes/screens/login_screen.dart';
import 'package:buybes/screens/user/cart_screen.dart';
import 'package:buybes/screens/user/products.dart';
import 'package:buybes/screens/user/track_orders.dart';
import 'package:buybes/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int navBarIndex = 0;
  FirebaseUser firebaseUser;
  final auth = Auth();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (navBarIndex) {
      case 0:
        child = Products();
        break;
      case 1:
        child = TrackDelivery();
        break;
    }
    return Stack(
      children: <Widget>[
        Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            onTap: (value) async {
              setState(() {
                navBarIndex = value;
              });
              if (value == 2) {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.clear();
                await auth.signOut();
                Navigator.popAndPushNamed(context, LoginScreen.id);
              }
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
                  'Track Orders',
                  style: TextStyle(
                    color: kUnActiveColor,
                  ),
                ),
                icon: Icon(Icons.add_location),
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
          body: SizedBox.expand(child: child),
        ),
        Material(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Discover'.toUpperCase(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, CartScreen.id);
                    },
                    child: Icon(Icons.shopping_cart),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  getCurrentUser() async {
    firebaseUser = await auth.getUser();
    getUserId();
  }

  getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString(kUserId, firebaseUser.uid);
  }
}
