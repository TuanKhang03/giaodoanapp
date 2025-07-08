import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderAdminPage extends StatefulWidget {
  const OrderAdminPage({super.key});

  @override
  State<OrderAdminPage> createState() => _OrderAdminPageState();
}

class _OrderAdminPageState extends State<OrderAdminPage> {
  Future<List<Map<String, dynamic>>> getAllUserOrders() async {
    final users = await FirebaseFirestore.instance.collection('users').get();
    List<Map<String, dynamic>> allOrders = [];
    for (var user in users.docs) {
      final orders = await user.reference.collection('orders').get();
      for (var order in orders.docs) {
        var data = order.data();
        data['orderId'] = order.id;
        data['userId'] = user.id;
        allOrders.add(data);
      }
    }
    return allOrders;
  }

  Future<void> updateOrderStatus(
    String userId,
    String orderId,
    String status,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('orders')
        .doc(orderId)
        .update({'status': status});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quản lý đơn hàng')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getAllUserOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          final orders = snapshot.data!;
          if (orders.isEmpty)
            return Center(child: Text('Chưa có đơn hàng nào.'));
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final data = orders[index];
              final status = data['status'] ?? 'Chờ xác nhận';
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('Tên: ${data['name'] ?? ''}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SĐT: ${data['phone'] ?? ''}'),
                      Text('Địa chỉ: ${data['address'] ?? ''}'),
                      Text('Tổng tiền: ${data['total'] ?? ''}đ'),
                      Text('Trạng thái: $status'),
                    ],
                  ),
                  trailing: DropdownButton<String>(
                    value: status,
                    items: ['Chờ xác nhận', 'Đang giao', 'Hoàn thành', 'Đã huỷ']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (newStatus) {
                      if (newStatus != null) {
                        updateOrderStatus(
                          data['userId'],
                          data['orderId'],
                          newStatus,
                        );
                        setState(() {}); // Cập nhật lại UI
                      }
                    },
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
