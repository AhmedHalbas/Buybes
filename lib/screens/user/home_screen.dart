import 'package:buybes/constants.dart';
import 'package:buybes/custom_widgets/products_view.dart';
import 'package:buybes/models/product.dart';
import 'package:buybes/screens/login_screen.dart';
import 'package:buybes/screens/user/cart_screen.dart';
import 'package:buybes/screens/user/product_info.dart';
import 'package:buybes/services/auth.dart';
import 'package:buybes/services/fire_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../functions.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tapBarIndex = 0;
  int navBarIndex = 0;
  FirebaseUser firebaseUser;
  final auth = Auth();
  FireStore _fireStore = FireStore();
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        DefaultTabController(
          length: 4,
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              onTap: (value) async {
                if (value == 1) {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
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
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              bottom: TabBar(
                indicatorColor: kMainColor,
                onTap: (value) {
                  setState(() {
                    tapBarIndex = value;
                  });
                },
                tabs: <Widget>[
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Jackets',
                      style: TextStyle(
                        color: tapBarIndex == 0 ? Colors.black : kUnActiveColor,
                        fontSize: tapBarIndex == 0 ? 16 : null,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Trousers',
                      style: TextStyle(
                        color: tapBarIndex == 1 ? Colors.black : kUnActiveColor,
                        fontSize: tapBarIndex == 1 ? 16 : null,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'T-Shirts',
                      style: TextStyle(
                        color: tapBarIndex == 2 ? Colors.black : kUnActiveColor,
                        fontSize: tapBarIndex == 2 ? 16 : null,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Shoes',
                      style: TextStyle(
                        color: tapBarIndex == 3 ? Colors.black : kUnActiveColor,
                        fontSize: tapBarIndex == 3 ? 16 : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                jacketView(),
                productsView(kTrousers, _products),
                productsView(kTshirts, _products),
                productsView(kShoes, _products),
              ],
            ),
          ),
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

  Widget jacketView() {
    return StreamBuilder<QuerySnapshot>(
        stream: _fireStore.viewProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Product> products = [];
            for (var doc in snapshot.data.documents) {
              var data = doc.data;
              products.add(
                Product(
                  pID: doc.documentID,
                  pName: data[kProductName],
                  pPrice: data[kProductPrice],
                  pDescription: data[kProductDescription],
                  pCategory: data[kProductCategory],
                  pLocation: data[kProductLocation],
                ),
              );
            }

            _products = [...products];
            products.clear();

            products = getProductsByCategory(kJackets, _products);
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.9),
              itemBuilder: (context, index) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ProductInfo.id,
                        arguments: products[index]);
                  },
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Image.asset(
                          products[index].pLocation,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Opacity(
                          opacity: 0.6,
                          child: Container(
                            color: Colors.white,
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  products[index].pName,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '\$${products[index].pPrice}',
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              itemCount: products.length,
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  getCurrentUser() async {
    firebaseUser = await auth.getUser();
  }
}
