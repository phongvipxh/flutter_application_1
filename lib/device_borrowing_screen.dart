import 'package:flutter/material.dart';

class DeviceBorrowingScreen extends StatelessWidget {
  const DeviceBorrowingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Danh sách phiếu mượn",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 5, // Giả định 5 phiếu mượn, có thể lấy từ API sau này
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    "Mã: ABC123", // In đậm mã phiếu
                    style: TextStyle(
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
                            Icon(Icons.person, size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Expanded(
                                child: Text(
                                    "Nguyễn Văn A")), // Bỏ chữ "Người mượn:"
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.date_range,
                                size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Expanded(child: Text("Trả trước: 2024-09-30")),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.info_outline,
                                size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Expanded(child: Text("Trạng thái: Chưa trả")),
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
                          _showMarkAsReturnedDialog(context);
                        },
                        child: Text("Đã trả"),
                      ),
                      TextButton(
                        onPressed: () {
                          _showDetailsDialog(context);
                        },
                        child: Text("Chi tiết"),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showMarkAsReturnedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận trả thiết bị"),
          content: Text("Bạn có chắc chắn muốn đánh dấu phiếu này là đã trả?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                // Gọi API để đánh dấu đã trả sau này
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text("Xác nhận"),
            ),
          ],
        );
      },
    );
  }

  void _showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Chi tiết phiếu mượn"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Mã phiếu: ABC123"),
              Text("Người mượn: Nguyễn Văn A"),
              Text("Ngày mượn: 2024-09-20"),
              Text("Trả trước: 2024-09-30"),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text("Đóng"),
            ),
          ],
        );
      },
    );
  }
}
