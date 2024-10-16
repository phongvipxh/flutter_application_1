import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/device_screen.dart';
import 'package:http/http.dart' as http;

class DeviceDetailsScreen extends StatefulWidget {
  final int deviceId; // Changed to deviceId to fetch from API

  DeviceDetailsScreen({required this.deviceId});

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  late Device device; // Declare a variable to store device details
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchDeviceDetails(); // Fetch device details when the screen initializes
  }

  Future<void> fetchDeviceDetails() async {
    final response = await http.get(
      Uri.parse(
          'https://sos-vanthuc-backend-bl1m.onrender.com/api/device/${widget.deviceId}'),
      headers: {
        'accept': 'application/json',
        // Add Authorization if needed
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        // Giải mã dữ liệu UTF-8
        var jsonData = json.decode(utf8.decode(response.bodyBytes));
        device = Device.fromJson(jsonData);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load device details');
    }
  }

  Future<void> updateDevice(
    int id,
    String name,
    String category,
    String information,
    String note,
    String image,
    int total,
    int totalUsed,
    int totalMaintenance,
    bool isActive,
    Function onSuccess,
  ) async {
    final response = await http.put(
      Uri.parse('https://sos-vanthuc-backend-bl1m.onrender.com/api/device/$id'),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'category': category,
        'information': information,
        'note': note,
        'image': image,
        'total': total,
        'total_used': totalUsed,
        'total_maintenance': totalMaintenance,
        'is_active': isActive,
      }),
    );

    if (response.statusCode == 200) {
      onSuccess();
      await fetchDeviceDetails();
    } else {
      throw Exception('Failed to update device');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Chi tiết thiết bị'),
        ),
        body: Center(
            child: CircularProgressIndicator()), // Show loading indicator
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi tiết thiết bị',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(
                context, true); // Indicate the previous screen should reload
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              _showEditForm(context, device);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem(
                  Icons.device_hub, 'Mã thiết bị:', device.id.toString()),
              _buildDetailItem(Icons.label, 'Tên thiết bị:', device.name),
              _buildDetailItem(
                  Icons.category, 'Loại thiết bị:', device.category),
              _buildDetailItem(Icons.info, 'Thông tin:', device.information),
              _buildDetailItem(Icons.note, 'Ghi chú:', device.note,
                  isWider: true),
              _buildDetailItem(Icons.format_list_numbered, 'Tổng số lượng:',
                  device.total.toString()),
              _buildDetailItem(Icons.check_circle, 'Đã sử dụng:',
                  device.totalUsed.toString()),
              _buildDetailItem(
                  Icons.build, 'Bảo trì:', device.totalMaintenance.toString()),
              _buildDetailItem(Icons.signal_cellular_alt, 'Trạng thái:',
                  device.isActive ? "Hoạt động" : "Không hoạt động"),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value,
      {bool isWider = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.orange),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                '$title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              flex: isWider ? 3 : 2,
              child: Text(
                value,
                style: TextStyle(fontSize: 18, color: Colors.black),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditForm(BuildContext context, Device device) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController =
        TextEditingController(text: device.name);
    final TextEditingController infoController =
        TextEditingController(text: device.information);
    final TextEditingController noteController =
        TextEditingController(text: device.note);
    final TextEditingController totalController =
        TextEditingController(text: device.total.toString());
    final TextEditingController usedController =
        TextEditingController(text: device.totalUsed.toString());
    final TextEditingController maintenanceController =
        TextEditingController(text: device.totalMaintenance.toString());

    String? selectedStatus = device.isActive ? "Hoạt động" : "Không hoạt động";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sửa thông tin thiết bị',
              style: TextStyle(color: Colors.black)),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Tên thiết bị'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên thiết bị';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    enabled: false,
                    decoration: InputDecoration(labelText: 'Loại thiết bị'),
                    initialValue: device.category,
                  ),
                  TextFormField(
                    controller: totalController,
                    decoration: InputDecoration(labelText: 'Tổng số lượng'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập số lượng';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: infoController,
                    decoration: InputDecoration(labelText: 'Thông tin'),
                  ),
                  TextFormField(
                    controller: noteController,
                    decoration: InputDecoration(labelText: 'Ghi chú'),
                    maxLines: 3,
                  ),
                  TextFormField(
                    controller: usedController,
                    decoration: InputDecoration(labelText: 'Đã sử dụng'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: maintenanceController,
                    decoration: InputDecoration(labelText: 'Bảo trì'),
                    keyboardType: TextInputType.number,
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: InputDecoration(labelText: 'Trạng thái'),
                    items: [
                      DropdownMenuItem(
                          child: Text('Hoạt động'), value: 'Hoạt động'),
                      DropdownMenuItem(
                          child: Text('Ngừng hoạt động'),
                          value: 'Ngừng hoạt động'),
                    ],
                    onChanged: (value) {
                      selectedStatus = value;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String name = nameController.text;
                  String category = device.category;
                  String information = infoController.text;
                  String note = noteController.text;
                  int total = int.parse(totalController.text);
                  int totalUsed = int.parse(usedController.text);
                  int totalMaintenance = int.parse(maintenanceController.text);
                  bool isActive = selectedStatus == 'Hoạt động';

                  updateDevice(
                    device.id,
                    name,
                    category,
                    information,
                    note,
                    "",
                    total,
                    totalUsed,
                    totalMaintenance,
                    isActive,
                    () {
                      setState(() {}); // Reload the screen after update
                    },
                  ).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Cập nhật thành công!')));
                    Navigator.of(context).pop(); // Close the dialog
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Cập nhật thất bại!')));
                  });
                }
              },
              child: Text('Cập nhật'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Hủy bỏ'),
            ),
          ],
        );
      },
    );
  }
}

// Assuming you have a Device model class
class Device {
  final int id;
  final String name;
  final String category;
  final String information;
  final String note;
  final int total;
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
    required this.totalUsed,
    required this.totalMaintenance,
    required this.isActive,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      information: json['information'],
      note: json['note'],
      total: json['total'],
      totalUsed: json['total_used'],
      totalMaintenance: json['total_maintenance'],
      isActive: json['is_active'] == 1, // Adjusted to handle integer values
    );
  }
}
