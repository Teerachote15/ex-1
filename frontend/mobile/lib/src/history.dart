import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // ตัวอย่างข้อมูลประวัติการสั่งซื้อ
  final List<Map<String, dynamic>> orderHistory = [
    {'orderId': '001', 'date': '2025-08-10', 'total': 450},
    {'orderId': '002', 'date': '2025-08-12', 'total': 1200},
    {'orderId': '003', 'date': '2025-08-14', 'total': 300},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ประวัติการสั่งซื้อ'),
      ),
      body: orderHistory.isEmpty
          ? const Center(
              child: Text('ไม่มีประวัติการสั่งซื้อ'),
            )
          : ListView.builder(
              itemCount: orderHistory.length,
              itemBuilder: (context, index) {
                final order = orderHistory[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text('รหัสคำสั่งซื้อ: ${order['orderId']}'),
                    subtitle: Text('วันที่: ${order['date']}'),
                    trailing: Text('฿${order['total']}'),
                  ),
                );
              },
            ),
    );
  }
}
