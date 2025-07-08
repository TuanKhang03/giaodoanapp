import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/pages/service/database.dart';

class HistoryOrderPage extends StatelessWidget {
  final String userId;
  const HistoryOrderPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    print('userId truyền vào HistoryOrderPage: $userId');
    return Scaffold(
      appBar: AppBar(title: Text('Lịch sử đơn hàng')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('orders')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data!.docs;
          print('Số lượng đơn hàng: ${orders.length}');
          if (orders.isEmpty) {
            return Center(child: Text('Bạn chưa có đơn hàng nào.'));
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final orderDoc = orders[index];
              final data = orderDoc.data() as Map<String, dynamic>;
              String ngayDat = '';
              if (data['createdAt'] != null && data['createdAt'] is Timestamp) {
                ngayDat = (data['createdAt'] as Timestamp).toDate().toString();
              }
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    'Trạng thái: ${data['status'] ?? 'Chờ xác nhận'}',
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tổng tiền: ${data['total'] ?? ''}đ'),
                      Text('Địa chỉ: ${data['address'] ?? ''}'),
                      Text('Ngày đặt: $ngayDat'),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () async {
                    // Lấy chi tiết đơn hàng bằng hàm trong DatabaseMethods
                    final detail = await DatabaseMethods().getOrderById(
                      userId,
                      orderDoc.id,
                    );
                    if (detail.exists) {
                      final detailData = detail.data();
                      // Hiển thị chi tiết đơn hàng (có thể show dialog hoặc sang trang mới)
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Chi tiết đơn hàng'),
                          content: Text(detailData.toString()),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
