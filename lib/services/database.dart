import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addProductDetails(
      Map<String, dynamic> ProductInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Product")
        .doc(id)
        .set(ProductInfoMap);
  }

  Future<Stream<QuerySnapshot>> getProductDetails() async {
    return await FirebaseFirestore.instance.collection("Product").snapshots();
  }

  Future updateProductDetails(
      String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance
        .collection("Product")
        .doc(id)
        .update(updateInfo);
  }

  Future deleteProductDetails(String id) async {
    return await FirebaseFirestore.instance
        .collection("Product")
        .doc(id)
        .delete();
  }
}
