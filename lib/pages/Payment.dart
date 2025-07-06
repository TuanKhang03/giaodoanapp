import 'dart:async';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/pages/service/Shared_pref.dart';
import 'package:mobileapp/pages/service/database.dart';
import 'package:mobileapp/widget/widget_support.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? id, wallet;
  int total = 0;
  Stream? foodStream;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String paymentMethod = 'wallet';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    id = await SharedPreferenceHelper().getUserID();
    wallet = await SharedPreferenceHelper().getUserWallet();
    foodStream = await DatabaseMethods().getFoodCart(id!);
    setState(() {});
  }

  Future<void> _handlePayment() async {
    if (nameController.text.trim().isEmpty || addressController.text.trim().isEmpty || phoneController.text.trim().isEmpty) {
      Flushbar(
        messageText: Center(
          child: Text('Vui lòng nhập đầy đủ tên, số điện thoại và địa chỉ!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Colors.red,
        borderRadius: BorderRadius.circular(10),
        margin: EdgeInsets.all(12),
        duration: Duration(seconds: 2),
        flushbarPosition: FlushbarPosition.TOP,
        icon: Icon(Icons.error, color: Colors.white),
      ).show(context);
      return;
    }
    setState(() { isLoading = true; });
    // Lấy danh sách sản phẩm trong giỏ hàng
    final cartSnapshot = await FirebaseFirestore.instance.collection('users').doc(id).collection('Cart').get();
    List<Map<String, dynamic>> items = cartSnapshot.docs.map((doc) => doc.data()).toList();
    total = 0;
    for (var doc in cartSnapshot.docs) {
      total += int.tryParse(doc['Total'] ?? '0') ?? 0;
    }
    String paymentLabel = '';
    if (paymentMethod == 'wallet') {
      int currentWallet = int.tryParse(wallet ?? '0') ?? 0;
      if (currentWallet < total) {
        setState(() { isLoading = false; });
        Flushbar(
          messageText: Center(
            child: Text('Số dư ví không đủ!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          backgroundColor: Colors.red,
          borderRadius: BorderRadius.circular(10),
          margin: EdgeInsets.all(12),
          duration: Duration(seconds: 2),
          flushbarPosition: FlushbarPosition.TOP,
          icon: Icon(Icons.error, color: Colors.white),
        ).show(context);
        return;
      }
      // Trừ tiền ví
      int newWallet = currentWallet - total;
      await DatabaseMethods().UpdateUserWallet(id!, newWallet.toString());
      await SharedPreferenceHelper().saveUserWallet(newWallet.toString());
      paymentLabel = 'Thanh toán bằng ví';
    } else {
      paymentLabel = 'Thanh toán khi nhận hàng';
    }
    // Lưu đơn hàng vào Firestore
    await DatabaseMethods().addOrderForUser({
      'userId': id,
      'name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
      'address': addressController.text.trim(),
      'items': items,
      'total': total,
      'paymentMethod': paymentLabel,
      'createdAt': FieldValue.serverTimestamp(),
    }, id!);
    // Xoá giỏ hàng
    await DatabaseMethods().clearFoodCart(id!);
    setState(() { isLoading = false; });
    Flushbar(
      messageText: Center(
        child: Text('Thanh toán thành công!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      backgroundColor: Colors.green,
      borderRadius: BorderRadius.circular(10),
      margin: EdgeInsets.all(12),
      duration: Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      icon: Icon(Icons.check_circle, color: Colors.white),
    ).show(context);
    // Reset form
    nameController.clear();
    phoneController.clear();
    addressController.clear();
    setState(() {});
  }

  Widget foodCart() {
    return StreamBuilder(
      stream: foodStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        final docs = snapshot.data.docs;
        if (docs.isEmpty) {
          return Center(child: Text('Giỏ hàng trống.'));
        }
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = docs[index];
            final quantity = int.tryParse(ds['Quantity']) ?? 1;
            final pricePerItem = (int.tryParse(ds['Total'] ?? '0') ?? 0) ~/ quantity;
            return Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.network(
                          ds['Image'],
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ds['Name'], style: AppWidget.SemiBoldTextFeildStyle()),
                            Text('${pricePerItem * quantity}đ', style: AppWidget.SemiBoldTextFeildStyle()),
                            Text('Số lượng: $quantity', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 2.0,
              child: Container(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Center(
                      child: Text(
                        "Thanh toán",
                        style: AppWidget.HeadlineTextFeildStyle(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            // Hiển thị danh sách sản phẩm lên trên
            Expanded(child: foodCart()),
            Divider(),
            // Các trường nhập thông tin và lựa chọn thanh toán xuống dưới
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Tên người nhận',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Số điện thoại',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Địa chỉ giao hàng',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          value: 'wallet',
                          groupValue: paymentMethod,
                          onChanged: (val) => setState(() => paymentMethod = val!),
                          title: Text('Thanh toán bằng ví'),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          value: 'cash',
                          groupValue: paymentMethod,
                          onChanged: (val) => setState(() => paymentMethod = val!),
                          title: Text('Tiền mặt'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tổng tiền:', style: AppWidget.boldTextFeildStyle()),
                  FutureBuilder(
                    future: FirebaseFirestore.instance.collection('users').doc(id).collection('Cart').get(),
                    builder: (context, snapshot) {
                      int sum = 0;
                      if (snapshot.hasData) {
                        for (var doc in (snapshot.data as QuerySnapshot).docs) {
                          sum += int.tryParse(doc['Total'] ?? '0') ?? 0;
                        }
                      }
                      return Text('${sum}đ', style: AppWidget.SemiBoldTextFeildStyle());
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GestureDetector(
                onTap: isLoading ? null : _handlePayment,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isLoading ? Colors.grey : Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Thanh toán",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
