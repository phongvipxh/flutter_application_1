import 'package:flutter/material.dart';

class DeviceDetailScreen extends StatelessWidget {
  final int id;
  final String name;
  final String info;
  final String note;
  final int total;
  final int used;
  final String maintenance;

  DeviceDetailScreen({
    required this.id,
    required this.name,
    required this.info,
    required this.note,
    required this.total,
    required this.used,
    required this.maintenance,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name, style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Mã thiết bị: $id", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Tên thiết bị: $name", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Thông tin: $info", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Ghi chú: $note", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Tổng số lượng: $total", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Đã sử dụng: $used", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Bảo trì: $maintenance", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
