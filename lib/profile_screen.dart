import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String full_name = "Đang tải...";
  String email = "Đang tải...";
  String phone_number = "Đang tải...";
  String role = "Đang tải...";
  String address = "Đang tải...";
  String birth_date = "Đang tải...";

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs
        .getString('access_token'); // Retrieve token with key 'access_token'
  }

  // Function to fetch profile data from the API
  Future<void> fetchProfileData() async {
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
      final profile = data['profile'];

      // Log the data for debugging
      print('Response data: $data');

      setState(() {
        full_name = profile['full_name'] ?? 'Không có tên';
        email = data['email'] ?? 'Không có email';
        phone_number = profile['phone_number'] ?? 'Không có số điện thoại';
        role = data['role'] == 2 ? 'Quản trị viên' : 'Không rõ vai trò';
        address = profile['address'] ?? 'Không có địa chỉ';
        birth_date = profile['birth_date'] ?? 'Không có ngày sinh';
      });
    } else {
      // Log an error if the API call fails
      print('Failed to load profile data. Status code: ${response.statusCode}');
      print(
          'Response body: ${utf8.decode(response.bodyBytes)}'); // Decode the error message

      setState(() {
        full_name = 'Lỗi khi lấy thông tin';
        email = 'Lỗi khi lấy thông tin';
        phone_number = 'Lỗi khi lấy thông tin';
        role = "Lỗi khi lấy thông tin";
        address = 'Lỗi khi lấy thông tin';
        birth_date = 'Lỗi khi lấy thông tin';
      });
    }
  }

  // Function to create information display rows
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
              color: Colors.grey[600], // Light gray color for labels
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87, // Darker text for info
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.grey[300], // Divider between info sections
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Thông tin cá nhân',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22, // Larger, bold title
            color: Colors.black, // Black text for title
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
              // Hardcoded avatar image from the given URL
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  'https://cellphones.com.vn/sforum/wp-content/uploads/2023/10/avatar-trang-4.jpg',
                ),
                backgroundColor:
                    Colors.grey[300], // Background color for avatar
              ),
              SizedBox(height: 16),
              _buildInfoRow('Họ và tên', full_name),
              _buildInfoRow('Email', email),
              _buildInfoRow('Số điện thoại', phone_number),
              _buildInfoRow('Vai trò', role),
              _buildInfoRow('Địa chỉ', address),
              _buildInfoRow('Ngày sinh', birth_date),
            ],
          ),
        ),
      ),
    );
  }
}
