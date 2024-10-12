import 'package:flutter/material.dart';

class AllDeviceScreen extends StatefulWidget {
  const AllDeviceScreen({super.key});

  @override
  _AllDeviceScreenState createState() => _AllDeviceScreenState();
}

class _AllDeviceScreenState extends State<AllDeviceScreen> {
  // Sample static device data
  List<Map<String, dynamic>> devices = [
    {
      'deviceId': 'D001',
      'type': 'Laptop',
      'name': 'Dell XPS 13',
      'totalQuantity': 10,
      'borrowed': 2,
      'available': 8,
    },
    {
      'deviceId': 'D002',
      'type': 'Tablet',
      'name': 'iPad Pro',
      'totalQuantity': 5,
      'borrowed': 1,
      'available': 4,
    },
    // Add more devices as needed
  ];

  List<Map<String, dynamic>> filteredDevices = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredDevices = devices; // Initialize with all devices
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
    String studentId = '';
    String studentName = '';
    DateTime returnDate = DateTime.now();
    String selectedDevice = '';
    int quantity = 1;

    // Biến để lưu thông báo lỗi
    String? studentIdError;
    String? studentNameError;
    String? deviceError;
    String? quantityError;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Tạo yêu cầu mượn thiết bị",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 400, // Set a fixed width for the dialog
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Mã sinh viên",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onChanged: (value) {
                      studentId = value;
                      studentIdError = null; // Reset error
                    },
                  ),
                  SizedBox(height: 8),
                  // Hiển thị thông báo lỗi dưới trường nhập liệu
                  if (studentIdError != null)
                    Text(studentIdError!, style: TextStyle(color: Colors.red)),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Tên sinh viên",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onChanged: (value) {
                      studentName = value;
                      studentNameError = null; // Reset error
                    },
                  ),
                  SizedBox(height: 8),
                  // Hiển thị thông báo lỗi dưới trường nhập liệu
                  if (studentNameError != null)
                    Text(studentNameError!,
                        style: TextStyle(color: Colors.red)),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Thời gian dự kiến trả",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: returnDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          returnDate = pickedDate;
                        });
                      }
                    },
                    controller: TextEditingController(
                      text: "${returnDate.toLocal()}".split(' ')[0],
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Tên thiết bị",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    items: filteredDevices.map((device) {
                      return DropdownMenuItem<String>(
                        value: device['deviceId'],
                        child: Text(device['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedDevice = value!;
                      deviceError = null; // Reset error
                    },
                  ),
                  SizedBox(height: 8),
                  // Hiển thị thông báo lỗi dưới trường nhập liệu
                  if (deviceError != null)
                    Text(deviceError!, style: TextStyle(color: Colors.red)),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Số lượng",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      quantity = int.tryParse(value) ?? 0;
                      quantityError = null; // Reset error
                    },
                  ),
                  SizedBox(height: 8),
                  // Hiển thị thông báo lỗi dưới trường nhập liệu
                  if (quantityError != null)
                    Text(quantityError!, style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),
          actions: [
            SizedBox(width: 20), // Add spacing to the left
            TextButton(
              child: Text("Hủy", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(width: 16), // Add spacing between buttons
            TextButton(
              child: Text("Mượn", style: TextStyle(color: Colors.orange)),
              onPressed: () {
                // Kiểm tra xem tất cả các trường đã được điền hay chưa
                setState(() {
                  studentIdError =
                      studentId.isEmpty ? "Vui lòng điền mã sinh viên." : null;
                  studentNameError = studentName.isEmpty
                      ? "Vui lòng điền tên sinh viên."
                      : null;
                  deviceError = selectedDevice.isEmpty
                      ? "Vui lòng chọn tên thiết bị."
                      : null;
                  quantityError =
                      quantity <= 0 ? "Vui lòng nhập số lượng hợp lệ." : null;
                });

                // Nếu tất cả đều hợp lệ, hiển thị thông báo thành công
                if (studentIdError == null &&
                    studentNameError == null &&
                    deviceError == null &&
                    quantityError == null) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Yêu cầu mượn thành công!"),
                  ));
                }
              },
            ),
            SizedBox(width: 20), // Add spacing to the right
          ],
        );
      },
    );
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
              "Tạo yêu cầu mượn thiết bị",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDevices.length,
              itemBuilder: (context, index) {
                final device = filteredDevices[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      "Mã: ${device['deviceId']}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.devices, size: 16, color: Colors.grey),
                              SizedBox(width: 4),
                              Text("Loại: ${device['type']}"),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.assignment,
                                  size: 16, color: Colors.grey),
                              SizedBox(width: 4),
                              Text("Tên thiết bị: ${device['name']}"),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.storage, size: 16, color: Colors.grey),
                              SizedBox(width: 4),
                              Text("Tổng số lượng: ${device['totalQuantity']}"),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.check, size: 16, color: Colors.grey),
                              SizedBox(width: 4),
                              Text("Đã cho mượn: ${device['borrowed']}"),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.check_circle,
                                  size: 16, color: Colors.grey),
                              SizedBox(width: 4),
                              Text("Sẵn sàng: ${device['available']}"),
                            ],
                          ),
                        ],
                      ),
                    ),
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
