import 'package:flutter/material.dart';
import 'feedback.dart';
import 'profile_screen.dart';
import 'login_screen.dart'; // Import màn hình đăng nhập

class AccountScreen extends StatelessWidget {
  final String userName = "Tên người dùng";
  final String userEmail = "email@domain.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông tin tài khoản',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22, // Kích thước tiêu đề lớn hơn
          ),
        ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar và Tên người dùng
                Center(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            'https://cellphones.com.vn/sforum/wp-content/uploads/2023/10/avatar-trang-4.jpg'), // Thay đổi với ảnh đại diện mới
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            userEmail,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                Divider(height: 40, thickness: 1),

                // Tùy chọn Trang cá nhân
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Trang cá nhân'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                ),

                Divider(height: 40, thickness: 1),

                // Phản hồi dưới dạng ListTile
                ListTile(
                  leading: Icon(Icons.feedback),
                  title: Text('Phản hồi'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FeedbackScreen()),
                    );
                  },
                ),

                Divider(height: 40, thickness: 1),

                // Đăng xuất với text và icon màu đỏ
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Colors.red, // Icon màu đỏ
                  ),
                  title: Text(
                    'Đăng xuất',
                    style: TextStyle(
                      color: Colors.red, // Chữ màu đỏ
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.red, // Mũi tên màu đỏ
                  ),
                  onTap: () {
                    _showLogoutDialog(
                        context); // Hiển thị pop-up khi nhấn Đăng xuất
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Hàm hiển thị dialog khi nhấn Đăng xuất
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận"),
          content: Text("Bạn có chắc chắn muốn đăng xuất không?"),
          actions: <Widget>[
            TextButton(
              child: Text("Không"),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng pop-up nếu chọn Không
              },
            ),
            TextButton(
              child: Text("Có"),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng pop-up trước khi đăng xuất
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) =>
                      false, // Xóa tất cả các trang trước đó và điều hướng đến màn hình đăng nhập
                );
              },
            ),
          ],
        );
      },
    );
  }
}
