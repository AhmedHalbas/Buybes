import 'package:buybes/custom_widgets/products_view.dart';
import 'package:buybes/functions.dart';
import 'package:buybes/models/product.dart';
import 'package:buybes/screens/user/product_info.dart';
import 'package:buybes/services/fire_store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class Products extends StatefulWidget {
  static String id = 'Products';
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  FireStore _fireStore = FireStore();
  List<Product> _products = [];
  int tapBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
                        child: CachedNetworkImage(
                          imageUrl: products[index].pLocation,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
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
}
