import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/devicelist_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'device_detail_screen.dart';

class DeviceScreen extends StatefulWidget {
  final String categoryName;

  DeviceScreen({required this.categoryName});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  late Future<List<Device>> devicesFuture;

  @override
  void initState() {
    super.initState();
    devicesFuture = fetchDevices();
  }

  Future<List<Device>> fetchDevices() async {
    final response = await http.get(Uri.parse(
        'https://sos-vanthuc-backend-bl1m.onrender.com/api/device?skip=0&limit=100'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Device.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load devices');
    }
  }

  Future<void> _refreshDevices() async {
    setState(() {
      devicesFuture = fetchDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName,
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
      body: RefreshIndicator(
        onRefresh: _refreshDevices, // Refresh function
        child: FutureBuilder<List<Device>>(
          future: devicesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final devices = snapshot.data!
                  .where((device) => device.category == widget.categoryName)
                  .toList();

              return ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  return DeviceCard(
                    device: devices[index],
                    onDelete: () {
                      _showDeleteDialog(context, index, devices);
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
      ),
    );
  }

  void _showAddDeviceDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
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
                  enabled: false, // Disable input for category field
                  controller: TextEditingController(
                      text: widget.categoryName), // Set default value
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
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    totalController.text.isNotEmpty) {
                  await addDevice(
                    name: nameController.text,
                    category: widget.categoryName,
                    total: int.parse(totalController.text),
                    information: infoController.text,
                    note: noteController.text,
                  );
                  // Cập nhật lại trạng thái để hiển thị thiết bị mới
                  setState(() {
                    devicesFuture =
                        fetchDevices(); // Tải lại danh sách thiết bị
                  });
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

  Future<void> addDevice({
    required String name,
    required String category,
    required int total,
    required String information,
    required String note,
  }) async {
    final response = await http.post(
      Uri.parse('https://sos-vanthuc-backend-bl1m.onrender.com/api/device'),
      headers: <String, String>{
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,
        'category': category,
        'information': information,
        'image': 'default.jpg', // Default image
        'note': note,
        'total': total,
      }),
    );

    if (response.statusCode == 200) {
      await fetchDevices();
    }
    if (response.statusCode != 200) {
      await fetchDevices();
      throw Exception('Failed to add device');
    }
  }

  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs
        .getString('access_token'); // Retrieve token with key 'access_token'
  }

  Future<void> deleteDevice(int deviceId) async {
    String? accessToken = await getAccessToken();

    final response = await http.delete(
      Uri.parse(
          'https://sos-vanthuc-backend-bl1m.onrender.com/api/device/$deviceId'),
      headers: <String, String>{
        'accept': 'application/json',
        'Authorization':
            'Bearer ${accessToken}', // Thay YOUR_ACCESS_TOKEN_HERE bằng token của bạn
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete device');
    }
  }

  void _showDeleteDialog(
      BuildContext context, int index, List<Device> devices) {
    final deviceToDelete = devices[index]; // Lấy thiết bị để xóa

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
              onPressed: () async {
                try {
                  await deleteDevice(deviceToDelete.id); // Gọi hàm xóa thiết bị
                  setState(() {}); // Gọi setState để cập nhật UI
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Xóa thiết bị không thành công!'),
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

  void _showDeviceDetails(BuildContext context, Device device) {
    // When navigating to DeviceDetailsScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceDetailsScreen(deviceId: device.id),
      ),
    ).then((shouldReload) {
      if (shouldReload == true) {
        // Call your method to reload data here
        fetchDevices(); // Replace with your actual method to fetch data
      }
    });
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
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          device.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Số lượng: ${device.total}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.info, color: Colors.blueAccent),
              onPressed: onViewDetails,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.redAccent),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
