import 'package:buybes/models/order.dart';
import 'package:buybes/screens/user/view_order_details_user.dart';
import 'package:buybes/services/fire_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class TrackDelivery extends StatefulWidget {
  static String id = 'TrackOrders';
  @override
  _TrackDeliveryState createState() => _TrackDeliveryState();
}

class _TrackDeliveryState extends State<TrackDelivery> {
  FireStore fireStore = FireStore();
  String uId;

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStore.viewOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Order> orders = [];
            for (var doc in snapshot.data.documents) {
              if (doc.data[kUserId] == uId)
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
                    Navigator.pushNamed(context, ViewOrderDetailsUser.id,
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
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Confirmation: ${orders[index].isConfirmed}',
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

  getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      uId = preferences.getString(kUserId);
    });
  }
}
