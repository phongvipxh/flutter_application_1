import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Thêm import cho http
import 'dart:convert';
import 'feedback.dart';
import 'profile_screen.dart';
import 'login_screen.dart'; // Import màn hình đăng nhập
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String userName = '';
  String userEmail = '';
  String userAvatar = '';

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Gọi hàm để lấy dữ liệu người dùng khi khởi tạo
  }

  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs
        .getString('access_token'); // Retrieve token with key 'access_token'
  }

  Future<void> fetchUserData() async {
    String? accessToken = await getAccessToken();
    print("Access token: $accessToken");

    final response = await http.get(
      Uri.parse('https://sos-vanthuc-backend-bl1m.onrender.com/api/auth/me'),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    if (response.statusCode == 200) {
      // Use utf8.decode to decode the response
      final data = json.decode(utf8.decode(response.bodyBytes));

      setState(() {
        userName = data['profile']['full_name'];
        userEmail = data['email'];
        userAvatar = data['profile']['avatar'] ?? ''; // Sử dụng avatar nếu có
      });
    } else {
      // Xử lý lỗi nếu không lấy được dữ liệu
      throw Exception('Failed to load user data');
    }
  }

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
                        backgroundImage: NetworkImage(userAvatar.isNotEmpty
                            ? userAvatar
                            : 'https://cellphones.com.vn/sforum/wp-content/uploads/2023/10/avatar-trang-4.jpg'), // Thay đổi với ảnh đại diện mới
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName.isNotEmpty ? userName : 'Tên người dùng',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            userEmail.isNotEmpty ? userEmail : 'Email',
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
  void _logout(BuildContext context) async {
    // Xóa token và thông tin đăng nhập đã lưu
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Xóa tất cả dữ liệu lưu trữ

    // Điều hướng đến màn hình đăng nhập và xóa ngăn xếp
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

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
                _logout(context); // Gọi hàm logout
              },
            ),
          ],
        );
      },
    );
  }
}
