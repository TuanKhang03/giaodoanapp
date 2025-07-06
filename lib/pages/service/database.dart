import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  // Cập nhật số lượng sản phẩm trong giỏ hàng
  Future<void> updateCartQuantity(String userId, String cartItemId, int newQuantity) async {
    final cartItemRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Cart')
        .doc(cartItemId);
    await cartItemRef.update({'Quantity': newQuantity.toString()});
  }
  // Xoá toàn bộ món trong giỏ hàng của user
  Future<void> clearFoodCart(String id) async {
    final cartRef = FirebaseFirestore.instance.collection('users').doc(id).collection('Cart');
    final cartItems = await cartRef.get();
    for (final doc in cartItems.docs) {
      await doc.reference.delete();
    }
  }
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfoMap);
  }

  UpdateUserWallet(String id, String amount) async {
    return await FirebaseFirestore.instance.collection('users').doc(id).update({
      "wallet": amount,
    });
  }

  Future addFoodItem(Map<String, dynamic> userInfoMap, String name) async {
    return await FirebaseFirestore.instance.collection(name).add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getFoodItem(String name) async {
    return FirebaseFirestore.instance.collection(name).snapshots();
  }

  Future addFoodtoCart(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection("Cart")
        .add(userInfoMap);
  }
  Future<Stream<QuerySnapshot>> getFoodCart(String id) async {
    return FirebaseFirestore.instance.collection("users").doc(id).collection("Cart").snapshots();
  }
 
}
