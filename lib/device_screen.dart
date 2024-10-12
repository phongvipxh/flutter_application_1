import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeviceScreen extends StatelessWidget {
  final String categoryName;

  DeviceScreen({required this.categoryName});
  Future<List<Device>> fetchDevices() async {
    final response = await http.get(Uri.parse(
        'https://sos-vanthuc-backend-bl1m.onrender.com/api/device?skip=0&limit=100'));

    if (response.statusCode == 200) {
      // Decode the response body with UTF-8
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));

      return data.map((json) => Device.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load devices');
    }
  }
  // print ra dữ liệu gọi  từ API

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            )),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddDeviceDialog(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Device>>(
        future: fetchDevices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final devices = snapshot.data!
                .where((device) => device.category == categoryName)
                .toList();
            print(devices);

            return ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return DeviceCard(
                  device: devices[index],
                  onDelete: () {
                    _showDeleteDialog(context, index);
                  },
                  onViewDetails: () {
                    _showDeviceDetails(context, devices[index]);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showAddDeviceDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController totalController = TextEditingController();
    final TextEditingController infoController = TextEditingController();
    final TextEditingController noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thêm thiết bị'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Tên thiết bị*',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    labelText: 'Loại thiết bị*',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: totalController,
                  decoration: InputDecoration(
                    labelText: 'Số lượng*',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: infoController,
                  decoration: InputDecoration(
                    labelText: 'Thông tin',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    labelText: 'Ghi chú',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Thêm"),
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    categoryController.text.isNotEmpty &&
                    totalController.text.isNotEmpty) {
                  // Thêm logic để lưu thiết bị mới vào danh sách
                  // Ví dụ:
                  // allDevices.add(Device(
                  //   id: allDevices.length + 1,
                  //   name: nameController.text,
                  //   category: categoryController.text,
                  //   total: int.parse(totalController.text),
                  // ));
                  Navigator.of(context).pop();
                } else {
                  // Hiển thị thông báo lỗi nếu các trường bắt buộc không được điền
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Vui lòng điền tất cả các trường bắt buộc!'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xóa thiết bị',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Bạn có chắc chắn muốn xóa thiết bị này?'),
          actions: <Widget>[
            TextButton(
              child: Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Xóa"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeviceDetails(BuildContext context, Device device) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(device.name, style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Mã thiết bị: ${device.id}'),
              Text('Số lượng: ${device.total}'),
              // Thêm thông tin khác nếu cần
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Đóng"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class Device {
  final int id;
  final String name;
  final String category;
  final String information;
  final String note;
  final int total;
  final String image;
  final int totalUsed;
  final int totalMaintenance;
  final bool isActive;

  Device({
    required this.id,
    required this.name,
    required this.category,
    required this.information,
    required this.note,
    required this.total,
    required this.image,
    required this.totalUsed,
    required this.totalMaintenance,
    required this.isActive,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      information: json['information'] ?? '',
      note: json['note'] ?? '',
      total: json['total'],
      image: json['image'],
      totalUsed: json['total_used'],
      totalMaintenance: json['total_maintenance'],
      isActive: json['is_active'] == 1,
    );
  }
}

class DeviceCard extends StatelessWidget {
  final Device device;
  final VoidCallback onDelete;
  final VoidCallback onViewDetails;

  const DeviceCard({
    Key? key,
    required this.device,
    required this.onDelete,
    required this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Mã thiết bị: ${device.id}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  Text(
                    'Số lượng: ${device.total}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.info, color: Colors.blueAccent),
              onPressed: onViewDetails,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
