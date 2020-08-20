import 'package:buybes/models/order.dart';
import 'package:buybes/models/product.dart';
import 'package:buybes/services/fire_store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class ViewOrderDetailsUser extends StatelessWidget {
  static String id = 'ViewOrderDetailsUser';

  @override
  Widget build(BuildContext context) {
    Order order = ModalRoute.of(context).settings.arguments;
    FireStore fireStore = FireStore();
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStore.viewOrderDetails(order.documentId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Product> products = [];
            for (var doc in snapshot.data.documents) {
              products.add(
                Product(
                  pName: doc.data[kProductName],
                  pPrice: doc.data[kProductPrice],
                  pQuantity: doc.data[kProductQuantity],
                  pLocation: doc.data[kProductLocation],
                ),
              );
            }
            return Builder(
              builder: (context) => Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          color: kSecondaryColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    products[index].pLocation),
                                radius: MediaQuery.of(context).size.height *
                                    0.15 /
                                    2,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                products[index].pName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                '\$${products[index].pPrice}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                '${products[index].pQuantity} PCs',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      itemCount: products.length,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: ButtonTheme(
                            buttonColor: kMainColor,
                            child: RaisedButton(
                              onPressed: () {
                                fireStore.deleteOrder(order.documentId);
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Order Cancelled'),
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              child: Text('Cancel Order'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
