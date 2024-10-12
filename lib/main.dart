import 'package:flutter/material.dart';
import 'login_screen.dart'; // Màn hình đăng nhập
import 'dashboard_screen.dart'; // Màn hình dashboard chính
import 'devicelist_screen.dart'; // Màn hình danh sách thiết bị
import 'package:flutter_application_1/account_screen.dart'; // Màn hình tài khoản
import 'manage_device.dart';
import 'user_management_screen.dart';
import 'package:flutter_application_1/account_screen.dart';

// import 'manage_room.dart'; // Màn hình quản lý phòng

void main() {
  runApp(MainApp()); // Changed to MainApp to avoid conflict
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', // Set Roboto as the default font
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16.0), // Previously bodyText2
          headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
      home: LoginScreen(), // Đặt MyApp là màn hình khởi đầu
    );
  }
}

// Màn hình chính với thanh điều hướng
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getSelectedScreen(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.devices),
            label: 'Danh sách thiết bị',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Quản lý mượn thiết bị',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Quản lý người dùng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Tài khoản',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey, // Non-selected icons are gray
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return DashboardScreen();
      case 1:
        return DeviceListScreen();
      case 2:
        return ManageDeviceScreen(); // Replace with your ManageDeviceScreen
      case 3:
        return UserManagementScreen(); // Replace with your ManageRoomScreen
      case 4:
        return AccountScreen();
      default:
        return DashboardScreen();
    }
  }
}
