import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllDeviceScreen extends StatefulWidget {
  const AllDeviceScreen({super.key});

  @override
  _AllDeviceScreenState createState() => _AllDeviceScreenState();
}

class _AllDeviceScreenState extends State<AllDeviceScreen> {
  List<Map<String, dynamic>> devices = [];
  List<Map<String, dynamic>> filteredDevices = [];
  List<Map<String, dynamic>> students = []; // Store student data here
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  String selectedStudentId = '';
  String selectedDeviceId = ''; // Thêm biến để lưu trữ device_id đã chọn
  DateTime returnDate = DateTime.now();
  TextEditingController returnDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDevices();
    fetchStudents(); // Fetch student data
    returnDateController.text = "${returnDate.toLocal()}"
        .split(' ')[0]; // Khởi tạo giá trị cho TextEditingController
  }

  Future<void> fetchDevices() async {
    final response = await http.get(
      Uri.parse(
          'https://sos-vanthuc-backend-bl1m.onrender.com/api/device?skip=0&limit=1000'),
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));

      setState(() {
        devices = data.map((device) {
          return {
            'deviceId': device['id'].toString(),
            'type': device['category'],
            'name': device['name'],
            'totalQuantity': device['total'],
            'borrowed': device['total_used'],
            'available': device['total'] - device['total_used'],
          };
        }).toList();

        filteredDevices = devices; // Initialize with all devices
      });
    } else {
      print('Failed to load devices');
    }
  }

  Future<void> fetchStudents() async {
    final response = await http.get(
      Uri.parse(
          'https://sos-vanthuc-backend-bl1m.onrender.com/api/customer?limit=1000&offset=0'),
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        students = data.map((student) {
          return {
            'studentId': student['id'].toString(),
            'fullName': student['full_name'],
          };
        }).toList();
      });
    } else {
      print('Failed to load students');
    }
  }

  void searchDevice(String query) {
    final filtered = devices.where((device) {
      final deviceName = device['name'].toLowerCase();
      final input = query.toLowerCase();
      return deviceName.contains(input);
    }).toList();

    setState(() {
      filteredDevices = filtered;
    });
  }

  void _showBorrowRequestForm(BuildContext context) {
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Tạo yêu cầu mượn thiết bị"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Chọn thiết bị'),
                  items: filteredDevices.map((device) {
                    return DropdownMenuItem<String>(
                      value: device['deviceId'],
                      child: Text(device['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDeviceId =
                          value ?? ''; // Lưu trữ device_id đã chọn
                    });
                  },
                ),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Số lượng'),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Chọn sinh viên'),
                  items: students.map((student) {
                    return DropdownMenuItem<String>(
                      value: student['studentId'],
                      child: Text(student['fullName']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedStudentId = value ?? '';
                  },
                ),
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(labelText: 'Ghi chú'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("Ngày trả:"),
                ),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: returnDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null && pickedDate != returnDate) {
                      setState(() {
                        returnDate = pickedDate;
                        returnDateController.text = "${returnDate.toLocal()}"
                            .split(
                                ' ')[0]; // Cập nhật ngày trả trong controller
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller:
                          returnDateController, // Sử dụng controller để hiển thị ngày trả
                      decoration: InputDecoration(
                        labelText: 'Ngày trả',
                        hintText: 'Nhấn để chọn ngày',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Gửi yêu cầu"),
              onPressed: () {
                _submitBorrowRequest(
                  selectedDeviceId, // Sử dụng device_id đã chọn
                  quantityController.text,
                  selectedStudentId,
                  noteController.text,
                  returnDate, // Nếu cần, có thể thay đổi cách truyền date
                );
                Navigator.of(context).pop(); // Đóng dialog sau khi gửi
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitBorrowRequest(
    String deviceId, // Sử dụng device_id từ input
    String quantity,
    String userId, // Student ID
    String note,
    DateTime returningDate,
  ) async {
    final response = await http.post(
      Uri.parse(
          'https://sos-vanthuc-backend-bl1m.onrender.com/api/device-borrowing'),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "name": "Borrow Request", // Bạn có thể tùy chỉnh tên này
        "devices": [
          {
            "device_id": deviceId, // Sử dụng device_id từ input
            "quantity": int.parse(quantity), // Đảm bảo đây là số nguyên
          },
        ],
        "user_id": 12, // Thay đổi thành ID người dùng thực nếu có
        "customer_id": int.parse(userId),
        "note": note,
        "returning_date": returningDate.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      print('Yêu cầu mượn đã được gửi thành công');
      // Có thể làm mới dữ liệu hoặc hiển thị thông báo thành công
    } else {
      print('Gửi yêu cầu mượn thất bại: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tất cả thiết bị",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Tìm kiếm thiết bị',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    searchDevice(searchController.text);
                  },
                ),
                prefixIcon: Icon(Icons.search, color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.teal, width: 2),
                ),
              ),
              onChanged: searchDevice,
            ),
          ),
          ElevatedButton(
            onPressed: () => _showBorrowRequestForm(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              textStyle: TextStyle(
                fontSize: 16,
              ),
            ),
            child: Text(
              "Yêu cầu mượn thiết bị",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDevices.length,
              itemBuilder: (context, index) {
                final device = filteredDevices[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      "${device['type']} - ${device['name']}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check, size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text("Tổng số: ${device['totalQuantity']}"),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.check_box, size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text("Đã mượn: ${device['borrowed']}"),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.check_circle,
                                size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text("Còn lại: ${device['available']}"),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigate to device detail screen if needed
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
