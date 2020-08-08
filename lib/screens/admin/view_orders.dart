import 'package:buybes/constants.dart';
import 'package:buybes/models/order.dart';
import 'package:buybes/screens/admin/view_order_details.dart';
import 'package:buybes/services/fire_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewOrders extends StatelessWidget {
  static String id = 'ViewOrders';
  FireStore fireStore = FireStore();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStore.viewOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Order> orders = [];
            for (var doc in snapshot.data.documents) {
              orders.add(Order(
                totalPrice: doc.data[kTotallPrice],
                address: doc.data[kAddress],
                documentId: doc.documentID,
                isConfirmed: doc.data[kIsConfirmed],
              ));
            }
            return ListView.builder(
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(15),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ViewOrderDetails.id,
                        arguments: orders[index]);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    color: kSecondaryColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Total Price: \$${orders[index].totalPrice}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Address: ${orders[index].address}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              itemCount: orders.length,
            );
          } else {
            return Center(
              child: Text('No Orders Yet'),
            );
          }
        },
      ),
    );
  }
}
