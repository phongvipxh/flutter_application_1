import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredStudents = [];
  List<Map<String, dynamic>> filteredLecturers = [];
  List<Map<String, dynamic>> students = []; // Danh sách sinh viên
  List<Map<String, dynamic>> lecturers = []; // Danh sách giảng viên

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchStudents(); // Lấy danh sách sinh viên
    fetchLecturers(); // Lấy danh sách giảng viên
  }

  Future<void> fetchStudents() async {
    try {
      students = await UserApiService.fetchStudents();
      if (mounted) {
        setState(() {
          filteredStudents = students; // Gán dữ liệu vào filteredStudents
        });
      }
    } catch (e) {
      print(e); // In lỗi nếu có
    }
  }

  Future<void> fetchLecturers() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://sos-vanthuc-backend-bl1m.onrender.com/api/customer/lecturer?limit=30&offset=0'),
        headers: {
          'accept': 'application/json; charset=utf-8'
        }, // Đảm bảo có charset=utf-8
      );

      if (response.statusCode == 200) {
        final String utf8String =
            utf8.decode(response.bodyBytes); // Sử dụng bodyBytes
        List jsonResponse = json.decode(utf8String);
        lecturers = jsonResponse
            .map((lecturer) => lecturer as Map<String, dynamic>)
            .toList();

        if (mounted) {
          setState(() {
            filteredLecturers = lecturers;
          });
        }
      } else {
        throw Exception('Failed to load lecturers');
      }
    } catch (e) {
      print(e); // In lỗi nếu có
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    searchController.dispose();
    super.dispose();
  }

  // Hàm tìm kiếm sinh viên
  void searchStudents(String query) {
    final filtered = students.where((student) {
      final studentName = student['name'].toLowerCase();
      final input = query.toLowerCase();
      return studentName.contains(input);
    }).toList();

    setState(() {
      filteredStudents = filtered;
    });
  }

  // Hàm tìm kiếm giảng viên
  // Hàm tìm kiếm giảng viên
  void searchLecturers(String query) {
    final filtered = lecturers.where((lecturer) {
      final lecturerName = lecturer['name'].toLowerCase();
      final input = query.toLowerCase();
      return lecturerName.contains(input);
    }).toList();

    setState(() {
      filteredLecturers = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Quản lý người dùng",
          style: TextStyle(
            fontWeight: FontWeight.w900, // Makes the text bold
            fontSize: 24, // Optional: Adjust the font size if needed
          ),
        ),
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Sinh viên'),
            Tab(text: 'Giảng viên'),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Tìm kiếm theo tên',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      if (_tabController?.index == 0) {
                        searchStudents(searchController.text);
                      } else {
                        searchLecturers(searchController.text);
                      }
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  if (_tabController?.index == 0) {
                    searchStudents(value);
                  } else {
                    searchLecturers(value);
                  }
                },
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  buildStudentList(),
                  buildLecturerList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Xây dựng danh sách sinh viên
  Widget buildStudentList() {
    return ListView.builder(
      itemCount: filteredStudents.length,
      itemBuilder: (context, index) {
        final student = filteredStudents[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(student['avatar']),
            ),
            title: Text(student['full_name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.cake, size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Ngày sinh: ${student['birth_date']}'),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.school, size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Mã sinh viên: ${student['id']}'),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.phone, size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Số điện thoại: ${student['phone_number']}'),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.business, size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('${student['department']}'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Xây dựng danh sách giảng viên
// Xây dựng danh sách giảng viên
  Widget buildLecturerList() {
    return ListView.builder(
      itemCount: filteredLecturers.length,
      itemBuilder: (context, index) {
        final lecturer = filteredLecturers[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(lecturer['avatar']),
            ),
            title: Text(lecturer['full_name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.badge, size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Mã giảng viên: ${lecturer['id']}'),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.phone, size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Số điện thoại: ${lecturer['phone_number']}'),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.cake, size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Ngày sinh: ${lecturer['birth_date']}'),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.business, size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('${lecturer['department']}'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class UserApiService {
  static Future<List<Map<String, dynamic>>> fetchStudents() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://sos-vanthuc-backend-bl1m.onrender.com/api/customer/student?limit=30&offset=0'),
        headers: {
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse
            .map((student) => student as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception('Failed to load students');
      }
    } catch (e) {
      print(e); // Print the error if there's one
      return []; // Return an empty list in case of an error
    }
  }

  static Future<List<Map<String, dynamic>>> fetchLecturers() async {
    return [
      {
        'avatar':
            'https://cellphones.com.vn/sforum/wp-content/uploads/2023/10/avatar-trang-4.jpg',
        'name': 'Le Van C',
        'id': 'GV001',
        'phone': '0123456789',
        'birth_date': '03/03/1980',
        'department': 'CNTT',
      },
      // Add more mock data
    ];
  }

  static Future<List<Map<String, dynamic>>> searchStudents(String query) async {
    // Implement API search logic here
    return fetchStudents().then((students) => students
        .where((student) =>
            student['name'].toLowerCase().contains(query.toLowerCase()))
        .toList());
  }

  static Future<List<Map<String, dynamic>>> searchLecturers(
      String query) async {
    // Implement API search logic here
    return fetchLecturers().then((lecturers) => lecturers
        .where((lecturer) =>
            lecturer['name'].toLowerCase().contains(query.toLowerCase()))
        .toList());
  }
}
