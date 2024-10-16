import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DeviceHistoryScreen extends StatefulWidget {
  const DeviceHistoryScreen({super.key});

  @override
  State<DeviceHistoryScreen> createState() => _DeviceHistoryScreenState();
}

class _DeviceHistoryScreenState extends State<DeviceHistoryScreen> {
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
        // Filtering borrowing data where is_returned is true
        borrowingList =
            data.where((item) => item['is_returned'] == true).toList();
      });
    } else {
      throw Exception('Failed to load borrowing data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch sử mượn thiết bị"),
      ),
      body: borrowingList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: borrowingList.length,
              itemBuilder: (context, index) {
                final request = borrowingList[index];
                final customer = request['customer'];
                final devices = request['devices'];

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      "Phiếu mượn: ${request['name']}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                              Text("Người mượn: ${customer['full_name']}"),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.phone,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text("SĐT: ${customer['phone_number']}"),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.date_range,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text("Ngày mượn: ${request['created_at']}"),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.event_available,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text("Ngày trả: ${request['returning_date']}"),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text("Thiết bị mượn:",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          for (var deviceItem in devices)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, top: 4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Tên thiết bị: ${deviceItem['device']['name']}"),
                                  Text("Số lượng: ${deviceItem['quantity']}"),
                                  Text("Trạng thái: ${deviceItem['status']}"),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        _viewDetails(request['id'].toString(), context);
                      },
                      child: const Text("Chi tiết"),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _viewDetails(String requestId, BuildContext context) async {
    final url = "https://phenikaa-uni.top/device-loan/$requestId";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Không thể mở liên kết: $url"),
      ));
    }
  }
}
