import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String _fullName = "Nguyễn Văn A";
  final String _email = "nguyenvana@example.com";
  final String _phone = "0901234567";
  final String _role = "Quản lý";
  final String _address = "123 Đường ABC, Quận XYZ, TP.HCM";
  final String _birthdate = "01/01/1990";

  // Hàm để tạo các dòng hiển thị thông tin
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600], // Màu chữ nhạt cho tiêu đề
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87, // Màu đậm hơn cho thông tin
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.grey[300], // Đường kẻ chia cách giữa các thông tin
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Background nhẹ nhàng
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Thông tin cá nhân',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22, // Larger, bold title
            color: Colors.black, // Màu chữ tiêu đề
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Ảnh đại diện cứng lấy từ link cung cấp
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  'https://cellphones.com.vn/sforum/wp-content/uploads/2023/10/avatar-trang-4.jpg',
                ), // Lấy ảnh từ link URL
                backgroundColor: Colors.grey[300], // Màu nền của ảnh
              ),
              SizedBox(height: 16),
              _buildInfoRow('Họ và tên', _fullName),
              _buildInfoRow('Email', _email),
              _buildInfoRow('Số điện thoại', _phone),
              _buildInfoRow('Vai trò', _role),
              _buildInfoRow('Địa chỉ', _address),
              _buildInfoRow('Ngày sinh', _birthdate),
            ],
          ),
        ),
      ),
    );
  }
}
