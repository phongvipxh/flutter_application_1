import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phản hồi của bạn'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Center(
                  child: Image.network(
                    'https://phenikaa-uni.top/logo/logo-title.png', // Đường dẫn đến logo của bạn
                    height: 100,
                  ),
                ),
                SizedBox(height: 20),

                // Form Feedback
                Form(
                  child: Column(
                    children: [
                      // Mã số sinh viên
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Mã số sinh viên',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Lý do
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Lý do',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'Lỗi hệ thống',
                            child: Text('Lỗi hệ thống'),
                          ),
                          DropdownMenuItem(
                            value: 'Lỗi thiết bị',
                            child: Text('Lỗi thiết bị'),
                          ),
                          DropdownMenuItem(
                            value: 'Lỗi đặt phòng',
                            child: Text('Lỗi đặt phòng'),
                          ),
                          DropdownMenuItem(
                            value: 'Khác',
                            child: Text('Khác'),
                          ),
                        ],
                        onChanged: (value) {
                          // Xử lý khi thay đổi lý do
                        },
                      ),
                      SizedBox(height: 20),

                      // Tiêu đề
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Tiêu đề',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Mô tả
                      TextFormField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Mô tả',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Nút gửi
                      ElevatedButton(
                        onPressed: () {
                          // Xử lý khi người dùng nhấn nút gửi
                        },
                        child: Text('Gửi phản hồi'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
