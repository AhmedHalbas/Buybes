import 'package:buybes/constants.dart';
import 'package:buybes/models/product.dart';
import 'package:buybes/screens/user/cart_screen.dart';
import 'package:buybes/services/auth.dart';
import 'package:buybes/services/fire_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductInfo extends StatefulWidget {
  static String id = 'ProductInfo';
  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  int _quantity = 1;
  FireStore fireStore = FireStore();
  final auth = Auth();
  CollectionReference _documentRef;
  List<String> cartProducts = [];
  String uId;

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getCartItems();

    Product product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image(
              image: AssetImage(product?.pLocation ?? ''),
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios),
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
          Positioned(
            bottom: 0,
            child: Column(
              children: <Widget>[
                Opacity(
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            product?.pName ?? '',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            product?.pDescription ?? '',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '\$${product?.pPrice ?? ''}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ClipOval(
                                  child: Material(
                                    color: kMainColor,
                                    child: GestureDetector(
                                      onTap: add,
                                      child: SizedBox(
                                        child: Icon(Icons.add),
                                        height: 45,
                                        width: 45,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    _quantity.toString(),
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                                ClipOval(
                                  child: Material(
                                    color: kMainColor,
                                    child: GestureDetector(
                                      onTap: subtract,
                                      child: SizedBox(
                                        child: Icon(Icons.remove),
                                        height: 45,
                                        width: 45,
                                      ),
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
                  opacity: 0.6,
                ),
                ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Builder(
                    builder: (context) => RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      color: kMainColor,
                      onPressed: () {
                        setState(() {
                          addToCart(context, product);
                        });
                      },
                      child: Text(
                        'Add To Cart'.toUpperCase(),
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  subtract() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        print(_quantity);
      });
    }
  }

  add() {
    setState(() {
      _quantity++;
      print(_quantity);
    });
  }

  getCartItems() {
    _documentRef = Firestore.instance
        .collection(kProductsToCartCollection)
        .document(uId)
        .collection(kUser);

    _documentRef.getDocuments().then((ds) {
      if (ds != null) {
        ds.documents.forEach((value) {
          cartProducts.add(value.data[kProductName]);
        });
      }
    });
  }

  getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      uId = preferences.getString(kUserId);
    });
  }

  void addToCart(context, product) {
    bool inCart = false;
    product.pQuantity = _quantity;

    for (String cartProduct in cartProducts) {
      if (product.pName == cartProduct) {
        inCart = true;
      }
    }

    if (inCart) {
      if (cartProducts != null) {
        EditCartData(product);
      }

      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully Edited in Cart'),
        ),
      );
    } else {
      SaveCartData(product);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to Cart'),
        ),
      );
    }
  }

  void SaveCartData(Product product) {
    fireStore.addProductToCart(product, uId);
  }

  void EditCartData(Product product) {
    fireStore.editCartItem(
      product.pID,
      uId,
      {
        kProductName: product.pName,
        kProductPrice: product.pPrice,
        kProductLocation: product.pLocation,
        kProductQuantity: product.pQuantity,
      },
    );
  }
}
