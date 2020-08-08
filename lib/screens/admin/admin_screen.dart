import 'package:buybes/constants.dart';
import 'package:buybes/screens/admin/add_product.dart';
import 'package:buybes/screens/admin/manage_products.dart';
import 'package:buybes/screens/admin/view_orders.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  static String id = 'AdminScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
