import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BorrowHistory {
  final String requestId;
  final String studentName;
  final String borrowDate;
  final String returnDate;
  final String lenderAccount;

  BorrowHistory({
    required this.requestId,
    required this.studentName,
    required this.borrowDate,
    required this.returnDate,
    required this.lenderAccount,
  });

  factory BorrowHistory.fromJson(Map<String, dynamic> json) {
    return BorrowHistory(
      requestId: json['requestId'],
      studentName: json['studentName'],
      borrowDate: json['borrowDate'],
      returnDate: json['returnDate'],
      lenderAccount: json['lenderAccount'],
    );
  }
}

class DeviceHistoryScreen extends StatelessWidget {
  const DeviceHistoryScreen({super.key});

  Future<List<BorrowHistory>> fetchBorrowHistory() async {
    List<Map<String, dynamic>> fakeApiResponse = [
      {
        'requestId': 'REQ123',
        'studentName': 'Nguyen Van A',
        'borrowDate': '2024-09-25',
        'returnDate': '2024-09-30',
        'lenderAccount': 'lender1',
      },
      {
        'requestId': 'REQ456',
        'studentName': 'Tran Thi B',
        'borrowDate': '2024-09-20',
        'returnDate': '2024-09-27',
        'lenderAccount': 'lender2',
      },
    ];

    return fakeApiResponse.map((data) => BorrowHistory.fromJson(data)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lịch sử mượn thiết bị"),
      ),
      body: FutureBuilder<List<BorrowHistory>>(
        future: fetchBorrowHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Đã xảy ra lỗi!"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Không có dữ liệu lịch sử mượn!"));
          } else {
            final borrowHistory = snapshot.data!;
            return ListView.builder(
              itemCount: borrowHistory.length,
              itemBuilder: (context, index) {
                final request = borrowHistory[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      "Mã phiếu: ${request.requestId}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person, size: 16, color: Colors.grey),
                              SizedBox(width: 4),
                              Text(request.studentName),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.date_range,
                                  size: 16, color: Colors.grey),
                              SizedBox(width: 4),
                              Text("Ngày mượn: ${request.borrowDate}"),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.event_available,
                                  size: 16, color: Colors.grey),
                              SizedBox(width: 4),
                              Text("Ngày trả: ${request.returnDate}"),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.account_circle,
                                  size: 16, color: Colors.grey),
                              SizedBox(width: 4),
                              Text("Người cho mượn: ${request.lenderAccount}"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        _viewDetails(request.requestId, context);
                      },
                      child: Text("Xem chi tiết"),
                    ),
                  ),
                );
              },
            );
          }
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
