import 'package:buybes/constants.dart';
import 'package:buybes/custom_widgets/custom_pop_up_menu.dart';
import 'package:buybes/models/product.dart';
import 'package:buybes/screens/admin/edit_product.dart';
import 'package:buybes/services/fire_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageProducts extends StatefulWidget {
  static String id = 'ManageProducts';
  @override
  _ManageProductsState createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts> {
  FireStore _fireStore = FireStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
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
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.9),
                itemBuilder: (context, index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: GestureDetector(
                    onTapUp: (details) {
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
                                Navigator.pushNamed(context, EditProduct.id,
                                    arguments: products[index]);
                              },
                            ),
                            MyPopUpMenuItem(
                              child: Text('Delete'),
                              onClick: () {
                                _fireStore.deleteProduct(products[index].pID);
                                Navigator.pop(context);
                              },
                            ),
                          ]);
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
          }),
    );
  }
}
