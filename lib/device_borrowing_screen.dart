import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeviceBorrowingScreen extends StatefulWidget {
  const DeviceBorrowingScreen({super.key});

  @override
  _DeviceBorrowingScreenState createState() => _DeviceBorrowingScreenState();
}

class _DeviceBorrowingScreenState extends State<DeviceBorrowingScreen> {
  List<dynamic> borrowingList = [];

  @override
  void initState() {
    super.initState();
    fetchBorrowingData();
  }

  Future<void> fetchBorrowingData() async {
    final response = await http.get(
      Uri.parse(
          'https://sos-vanthuc-backend-bl1m.onrender.com/api/device-borrowing?skip=0&limit=100'),
      headers: {
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final List<dynamic> data = jsonDecode(decodedResponse);

      setState(() {
        // Lọc các phiếu mượn có is_returned = false
        borrowingList =
            data.where((item) => item['is_returned'] == false).toList();
      });
    } else {
      print('Failed to load borrowing data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Danh sách phiếu mượn",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: fetchBorrowingData, // Function to call on pull-to-refresh
        child: borrowingList.isEmpty
            ? const Center(child: Text("Không có phiếu mượn"))
            : ListView.builder(
                itemCount: borrowingList.length,
                itemBuilder: (context, index) {
                  final borrowing = borrowingList[index];
                  final customer = borrowing['customer'];
                  final device = borrowing['devices'][0]['device'];

                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        "Mã: ${borrowing['id']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.person,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                    child: Text("${customer['full_name']}")),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.date_range,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                    child: Text(
                                        "Trả trước: ${borrowing['returning_date']}")),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.info_outline,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                    child: Text(
                                        "Trạng thái: ${borrowing['is_returned'] ? 'Đã trả' : 'Chưa trả'}")),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.devices,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                    child: Text("Thiết bị: ${device['name']}")),
                              ],
                            ),
                          ],
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {
                              _showMarkAsReturnedDialog(context, borrowing);
                            },
                            child: const Text("Đã trả"),
                          ),
                          TextButton(
                            onPressed: () {
                              _showDetailsDialog(context, borrowing);
                            },
                            child: const Text("Chi tiết"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _showMarkAsReturnedDialog(BuildContext context, dynamic borrowing) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận trả thiết bị"),
          content:
              const Text("Bạn có chắc chắn muốn đánh dấu phiếu này là đã trả?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () async {
                // Gọi API để đánh dấu đã trả
                await markAsReturned(borrowing);
                Navigator.of(context).pop(); // Đóng dialog và tải lại dữ liệu
                fetchBorrowingData(); // Tải lại danh sách sau khi cập nhật
              },
              child: const Text("Xác nhận"),
            ),
          ],
        );
      },
    );
  }

  Future<void> markAsReturned(dynamic borrowing) async {
    final borrowingId = borrowing['id'];
    final deviceId = borrowing['devices'][0]['device']['id'];

    // Tạo payload cho request PUT
    final payload = {
      'device_borrowing_id': borrowingId,
      'devices': [
        {
          'device_id': deviceId,
          'quantity_return': 1, // Số lượng trả (tùy chỉnh nếu cần)
          'status': 'done', // Trạng thái của thiết bị
          'note': '' // Ghi chú nếu có
        }
      ],
      'note': '',
      'retry': false, // Retry nếu cần
    };

    final response = await http.put(
      Uri.parse(
          'https://sos-vanthuc-backend-bl1m.onrender.com/api/device-borrowing/$borrowingId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      // Đánh dấu thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã đánh dấu là đã trả thành công")),
      );
    } else {
      // Xử lý lỗi nếu có
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Có lỗi xảy ra: ${response.body}")),
      );
    }
  }

  void _showDetailsDialog(BuildContext context, dynamic borrowing) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final customer = borrowing['customer'];
        return AlertDialog(
          title: const Text("Chi tiết phiếu mượn"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Mã phiếu: ${borrowing['id']}"),
              Text("Người mượn: ${customer['full_name']}"),
              Text("Ngày mượn: ${borrowing['created_at']}"),
              Text("Trả trước: ${borrowing['returning_date']}"),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text("Đóng"),
            ),
          ],
        );
      },
    );
  }
}
