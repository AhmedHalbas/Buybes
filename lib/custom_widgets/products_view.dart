import 'package:buybes/functions.dart';
import 'package:buybes/models/product.dart';
import 'package:buybes/screens/user/product_info.dart';
import 'package:flutter/material.dart';

Widget productsView(String category, List<Product> allProducts) {
  List<Product> products = [];
  products = getProductsByCategory(category, allProducts);
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, childAspectRatio: 0.9),
    itemBuilder: (context, index) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
}
