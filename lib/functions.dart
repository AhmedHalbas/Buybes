import 'package:buybes/models/product.dart';

List<Product> getProductsByCategory(
    String category, List<Product> allProducts) {
  List<Product> products = [];

  for (var product in allProducts) {
    if (product.pCategory == category) {
      products.add(product);
    }
  }

  return products;
}
