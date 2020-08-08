import 'package:buybes/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buybes/constants.dart';

class FireStore {
  final Firestore _firestore = Firestore.instance;

  addProduct(Product product) {
    _firestore.collection(kProductsCollection).add({
      kProductName: product.pName,
      kProductPrice: product.pPrice,
      kProductDescription: product.pDescription,
      kProductCategory: product.pCategory,
      kProductLocation: product.pLocation,
    });
  }

  Stream<QuerySnapshot> viewProducts() {
    return _firestore.collection(kProductsCollection).snapshots();
  }

  Stream<QuerySnapshot> viewOrders() {
    return _firestore.collection(kOrders).snapshots();
  }

  Stream<QuerySnapshot> viewOrderDetails(documentId) {
    return _firestore
        .collection(kOrders)
        .document(documentId)
        .collection(kOrderDetails)
        .snapshots();
  }

  deleteProduct(documentID) {
    _firestore.collection(kProductsCollection).document(documentID).delete();
  }

  editProduct(documentID, data) {
    _firestore
        .collection(kProductsCollection)
        .document(documentID)
        .updateData(data);
  }

  editOrder(documentID, data) {
    _firestore.collection(kOrders).document(documentID).updateData(data);
  }

  deleteOrder(documentID) {
    _firestore.collection(kOrders).document(documentID).delete();
  }

  storeOrders(data, List<Product> products) {
    var documentReference = _firestore.collection(kOrders).document();
    documentReference.setData(data);

    for (var product in products) {
      documentReference.collection(kOrderDetails).document().setData({
        kProductName: product.pName,
        kProductPrice: product.pPrice,
        kProductQuantity: product.pQuantity,
        kProductLocation: product.pLocation,
      });
    }
  }
}
