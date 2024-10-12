import 'package:flutter/material.dart';
import 'dart:convert'; // Để xử lý JSON
import 'package:http/http.dart' as http; // Để gọi API
import 'device_screen.dart'; // Import device_screen.dart

class DeviceListScreen extends StatefulWidget {
  @override
  _DeviceListScreenState createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  List<Device> devices = [];

  @override
  void initState() {
    super.initState();
    fetchDevices(); // Gọi API khi khởi động màn hình
  }

  Future<void> fetchDevices() async {
    final response = await http.get(
      Uri.parse(
          'https://sos-vanthuc-backend-bl1m.onrender.com/api/device-category?skip=0&limit=100'),
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Chuyển đổi dữ liệu với UTF-8
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        devices = data
            .map((item) => Device(
                  id: item['id'],
                  name: item['name'],
                  isActive: item['is_active'],
                  totalDevices: item['total_devices'],
                  imageUrl: item['presigned_url'].isNotEmpty
                      ? item['presigned_url']
                      : item['image'],
                ))
            .toList();
      });
    } else {
      print('Failed to load devices');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách thiết bị',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            )),
        backgroundColor: Colors.white,
      ),
      body: devices.isEmpty
          ? Center(
              child:
                  CircularProgressIndicator()) // Hiển thị loading khi dữ liệu chưa được load
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  return DeviceCard(
                    device: devices[index],
                    onEdit: () {
                      _showEditDialog(context, devices[index]);
                    },
                    onDelete: () {
                      _showDeleteDialog(context, index);
                    },
                    onTap: () {
                      // Điều hướng đến DeviceScreen với category name
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DeviceScreen(categoryName: devices[index].name),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    String deviceName = '';
    String imageUrl = ''; // Thêm biến để lưu trữ đường dẫn hình ảnh

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thêm thiết bị',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: "Nhập tên thiết bị"),
                onChanged: (value) {
                  deviceName = value; // Lưu giá trị vào biến
                },
              ),
              TextField(
                decoration:
                    InputDecoration(hintText: "Nhập đường dẫn hình ảnh"),
                onChanged: (value) {
                  imageUrl = value; // Lưu giá trị vào biến
                },
              ),
            ],
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
              onPressed: () async {
                // Gọi hàm thêm loại thiết bị
                await addDeviceCategory(deviceName, imageUrl);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> addDeviceCategory(String name, String image) async {
    final response = await http.post(
      Uri.parse(
          'https://sos-vanthuc-backend-bl1m.onrender.com/api/device-category'),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,
        'is_active': true,
        'image': image,
      }),
    );

    if (response.statusCode == 200) {
      // Nếu thêm thành công, có thể làm gì đó ở đây, như refresh danh sách thiết bị
      print('Device category added successfully');
      fetchDevices(); // Tải lại danh sách thiết bị
    } else {
      // Nếu thêm không thành công
      print('Failed to add device category');
      fetchDevices(); // Tải lại danh sách thiết bị
    }
  }

  void _showEditDialog(BuildContext context, Device device) {
    final TextEditingController editController =
        TextEditingController(text: device.name);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sửa loại thiết bị',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            decoration: InputDecoration(hintText: "Nhập tên loại thiết bị"),
            controller: editController,
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Lưu"),
              onPressed: () {
                // Gọi hàm chỉnh sửa thiết bị ở đây nếu cần
                Navigator.of(context).pop();
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
                // Gọi hàm xóa thiết bị ở đây nếu cần
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class DeviceCard extends StatelessWidget {
  final Device device;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const DeviceCard({
    Key? key,
    required this.device,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${device.totalDevices} chiếc',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blueAccent),
                onPressed: onEdit,
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.redAccent),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Device {
  final int id;
  final String name;
  final bool isActive;
  final int totalDevices;
  final String imageUrl;

  Device({
    required this.id,
    required this.name,
    required this.isActive,
    required this.totalDevices,
    required this.imageUrl,
  });
}
