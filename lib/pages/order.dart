import 'dart:async';
import 'package:another_flushbar/flushbar.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/pages/service/Shared_pref.dart';
import 'package:mobileapp/pages/service/database.dart';
import 'package:mobileapp/widget/widget_support.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? id, wallet;
  int total = 0, amount2 = 0;
  Timer? _timer;

  void starttimer() {
    _timer = Timer(Duration(seconds: 1), () {
      amount2 = total;
      if (mounted) {
        setState(() {});
      }
    });
  }

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserID();
    wallet = await SharedPreferenceHelper().getUserWallet();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    foodStream = await DatabaseMethods().getFoodCart(id!);
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    starttimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Stream? foodStream;
  // Controllers to manage quantity input for each cart item
  final Map<String, TextEditingController> _quantityControllers = {};
  final Map<String, int> _quantityValues = {};
  String? _selectedCartItemId;

  Widget foodCart() {
    return StreamBuilder(
      stream: foodStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        final docs = snapshot.data.docs;
        total = 0;
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: docs.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = docs[index];
            final cartItemId = ds.id;
            final quantity = int.tryParse(ds["Quantity"]) ?? 1;
            final pricePerItem = (int.tryParse(ds["Total"] ?? "0") ?? 0) ~/ quantity;
            total += int.tryParse(ds["Total"] ?? "0") ?? 0;

            // Setup controller and value for each cart item
            _quantityControllers.putIfAbsent(cartItemId, () => TextEditingController(text: quantity.toString()));
            _quantityValues.putIfAbsent(cartItemId, () => quantity);

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
                      // Quantity controls: number box, then up/down arrows outside
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 90,
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: TextField(
                              controller: _quantityControllers[cartItemId],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              onChanged: (val) {
                                int? v = int.tryParse(val);
                                if (v != null && v > 0) {
                                  setState(() {
                                    _quantityValues[cartItemId] = v;
                                    _selectedCartItemId = cartItemId;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          SizedBox(width: 6),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 28,
                                height: 28,
                                child: IconButton(
                                  icon: Icon(Icons.arrow_drop_up, size: 20),
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  onPressed: () {
                                    int current = _quantityValues[cartItemId] ?? quantity;
                                    setState(() {
                                      _quantityValues[cartItemId] = current + 1;
                                      _quantityControllers[cartItemId]?.text = (current + 1).toString();
                                      _selectedCartItemId = cartItemId;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 28,
                                height: 28,
                                child: IconButton(
                                  icon: Icon(Icons.arrow_drop_down, size: 20),
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  onPressed: () {
                                    int current = _quantityValues[cartItemId] ?? quantity;
                                    if (current > 1) {
                                      setState(() {
                                        _quantityValues[cartItemId] = current - 1;
                                        _quantityControllers[cartItemId]?.text = (current - 1).toString();
                                        _selectedCartItemId = cartItemId;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(width: 20.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.network(
                          ds["Image"],
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ds["Name"],
                            style: AppWidget.SemiBoldTextFeildStyle(),
                          ),
                          Text(
                            (pricePerItem * (_quantityValues[cartItemId] ?? quantity)).toString() + "\đ",
                            style: AppWidget.SemiBoldTextFeildStyle(),
                          )
                        ],
                      ),
                      Spacer(),
                      // Nút xoá sản phẩm với xác nhận
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Xác nhận xoá'),
                              content: Text('Bạn có chắc chắn muốn xoá sản phẩm này khỏi giỏ hàng?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: Text('Huỷ'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: Text('Xoá', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(id)
                                .collection('Cart')
                                .doc(cartItemId)
                                .delete();
                            setState(() {});
                            Flushbar(
                              messageText: Center(
                                child: Text(
                                  'Đã xoá sản phẩm khỏi giỏ hàng!',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                              backgroundColor: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                              margin: EdgeInsets.all(12),
                              duration: Duration(seconds: 2),
                              flushbarPosition: FlushbarPosition.TOP,
                              icon: Icon(Icons.check_circle, color: Colors.white),
                            ).show(context);
                          }
                        },
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
                child: Center(
                  child: Text(
                    "Giỏ hàng",
                    style: AppWidget.HeadlineTextFeildStyle(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: foodCart(),
            ),
            // Nút cập nhật số lượng chỉ hiện khi giỏ hàng có sản phẩm
            Builder(
              builder: (context) {
                final hasCart = (foodStream != null && (foodStream as Stream).runtimeType.toString().contains('QuerySnapshot')) || (foodStream != null);
                // Đếm số sản phẩm trong cart
                // Nếu không có sản phẩm thì không hiển thị nút
                return (foodStream != null && (foodStream as Stream).runtimeType.toString().contains('QuerySnapshot'))
                  ? StreamBuilder(
                      stream: foodStream,
                      builder: (context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData || snapshot.data.docs.length == 0) {
                          return SizedBox.shrink();
                        }
                        return Column(
                          children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (_selectedCartItemId == null) return;
                                    int? newQuantity = _quantityValues[_selectedCartItemId!];
                                    if (newQuantity == null || newQuantity < 1) return;
                                    // Lấy lại thông tin sản phẩm để tính lại tổng tiền
                                    final doc = await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(id)
                                        .collection('Cart')
                                        .doc(_selectedCartItemId)
                                        .get();
                                    final oldQuantity = int.tryParse(doc["Quantity"] ?? "1") ?? 1;
                                    final oldTotal = int.tryParse(doc["Total"] ?? "0") ?? 0;
                                    final pricePerItem = oldTotal ~/ oldQuantity;
                                    int newTotal = pricePerItem * newQuantity;
                                    await DatabaseMethods().updateCartQuantity(id!, _selectedCartItemId!, newQuantity);
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(id)
                                        .collection('Cart')
                                        .doc(_selectedCartItemId)
                                        .update({'Total': newTotal.toString()});
                                    setState(() {});
                                    Flushbar(
                                      messageText: Center(
                                        child: Text(
                                          'Đã cập nhật số lượng!',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      backgroundColor: Colors.green,
                                      borderRadius: BorderRadius.circular(10),
                                      margin: EdgeInsets.all(12),
                                      duration: Duration(seconds: 2),
                                      flushbarPosition: FlushbarPosition.TOP,
                                      icon: Icon(Icons.check_circle, color: Colors.white),
                                    ).show(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10.0),
                                    width: MediaQuery.of(context).size.width * 0.5,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Cập nhật",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        );
                      },
                    )
                  : SizedBox.shrink();
              },
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tổng tiền: ",
                    style: AppWidget.boldTextFeildStyle(),
                  ),
                  Text(
                    total.toString() + "\đ",
                    style: AppWidget.SemiBoldTextFeildStyle(),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () async {
                int amount = int.parse(wallet!) - amount2;
                await DatabaseMethods().UpdateUserWallet(id!, amount.toString());
                await SharedPreferenceHelper().saveUserWallet(amount.toString());
                await DatabaseMethods().clearFoodCart(id!); // Xoá giỏ hàng
                setState(() {
                  total = 0;
                  amount2 = 0;
                });
                Flushbar(
                  messageText: Center(
                    child: Text(
                      'Thanh toán thành công. Giỏ hàng đã được làm mới!',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  backgroundColor: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                  margin: EdgeInsets.all(12),
                  duration: Duration(seconds: 2),
                  flushbarPosition: FlushbarPosition.TOP,
                  icon: Icon(Icons.check_circle, color: Colors.white),
                ).show(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                margin:
                    EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Center(
                    child: Text(
                  "Thanh toán",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
