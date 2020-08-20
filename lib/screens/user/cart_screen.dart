import 'package:buybes/constants.dart';
import 'package:buybes/custom_widgets/custom_pop_up_menu.dart';
import 'package:buybes/models/product.dart';
import 'package:buybes/screens/user/product_info.dart';
import 'package:buybes/services/fire_store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  static String id = 'CartScreen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  FireStore _fireStore = FireStore();
  List<Product> products;
  String uId;

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'My Cart',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
              stream: _fireStore.getCartData(uId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  products = [];
                  for (var doc in snapshot.data.documents) {
                    var data = doc.data;

                    products.add(
                      Product(
                        pID: doc.documentID,
                        pName: data[kProductName],
                        pPrice: data[kProductPrice],
                        pLocation: data[kProductLocation],
                        pQuantity: data[kProductQuantity],
                      ),
                    );
                  }

                  return Container(
                    height: screenHeight -
                        statusBarHeight -
                        appBarHeight -
                        (screenHeight * 0.1),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: GestureDetector(
                            onTapUp: (details) {
                              showCustomMenu(
                                  details, context, products[index], index);
                            },
                            child: Container(
                              color: kMainColor,
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        products[index].pLocation),
                                    radius: screenHeight * 0.15 / 2,
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                products[index].pName,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '\$${products[index].pPrice}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: Text(
                                            '${products[index].pQuantity.toString()} Pcs',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: products.length,
                    ),
                  );
                } else {
                  return Container(
                    height: screenHeight -
                        (screenHeight * 0.1) -
                        appBarHeight -
                        statusBarHeight,
                    child: Center(
                      child: Text(
                        'Cart is Empty',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  );
                }
              }),
          Builder(
            builder: (context) => ButtonTheme(
              height: screenHeight * 0.1,
              minWidth: screenWidth,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: RaisedButton(
                onPressed: () {
                  customDialog(products, context);
                },
                child: Text('Order Now'.toUpperCase()),
                color: kMainColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  void showCustomMenu(details, context, product, index) {
    double dx = details.globalPosition.dx;
    double dy = details.globalPosition.dy;
    double dx2 = MediaQuery.of(context).size.width - dx;
    double dy2 = MediaQuery.of(context).size.height - dy;
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
        items: [
          MyPopUpMenuItem(
            child: Text('Edit'),
            onClick: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, ProductInfo.id, arguments: product);
            },
          ),
          MyPopUpMenuItem(
            child: Text('Delete'),
            onClick: () {
              Navigator.pop(context);
              _fireStore.deleteCartItem(product.pID, uId);
            },
          ),
        ]);
  }

  void customDialog(List<Product> products, context) async {
    var totalPrice = calcTotalPrice(products);
    String address;

    AlertDialog alertDialog = AlertDialog(
      actions: <Widget>[
        MaterialButton(
          child: Text('Confirm'),
          onPressed: () {
            try {
              FireStore fireStore = FireStore();
              fireStore.storeOrders({
                kTotallPrice: totalPrice,
                kAddress: address,
                kIsConfirmed: false,
                kUserId: uId,
              }, products);
              Navigator.pop(context);
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ordered Successfully'),
                ),
              );
            } catch (e) {
              print(e.message);
            }
          },
        )
      ],
      title: Text('Total Price  = \$$totalPrice'),
      content: TextField(
        onChanged: (value) {
          address = value;
        },
        decoration: InputDecoration(
          hintText: 'Enter Your Home Address',
        ),
      ),
    );

    await showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  calcTotalPrice(List<Product> products) {
    var totalPrice = 0;
    for (var product in products) {
      totalPrice += product.pQuantity * int.parse(product.pPrice);
    }

    return totalPrice;
  }

  getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      uId = preferences.getString(kUserId);
    });
  }
}
