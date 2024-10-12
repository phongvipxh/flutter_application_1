import 'package:flutter/material.dart';
import 'all_device_screen.dart';
import 'device_borrowing_screen.dart';
import 'device_history_screen.dart';

class ManageDeviceScreen extends StatelessWidget {
  const ManageDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        title: Text(
          'Quản Lý Mượn Thiết Bị',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24, // Larger, bold title
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 16.0), // Vertical padding for the entire list
        child: ListView(
          children: <Widget>[
            _buildContainer(context, Icons.device_hub, 'Danh Sách Thiết Bị'),
            _buildContainer(
                context, Icons.assignment_returned, 'Danh Sách Đang Mượn'),
            _buildContainer(context, Icons.history, 'Tra Cứu Lịch Sử Mượn'),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer(BuildContext context, IconData icon, String title) {
    return GestureDetector(
      onTap: () {
        _navigateToScreen(context, title);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: 30, horizontal: 20), // Increased height
        decoration: BoxDecoration(
          color: Colors.white, // Background color for containers
          border: Border(
            top: BorderSide(
                color: Colors.grey.shade300, width: 1.0), // Lighter top border
            // Removed bottom border
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.grey), // Reduced icon size
            SizedBox(width: 20), // Space between icon and text
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16, // Reduced font size
                  fontWeight: FontWeight.normal, // Regular font weight
                  color: Colors.black, // Text color
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 20, color: Colors.grey), // Reduced size of the arrow icon
          ],
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, String title) {
    Widget screen;
    switch (title) {
      case 'Danh Sách Thiết Bị':
        screen = AllDeviceScreen(); // Replace with actual screen
        break;
      case 'Danh Sách Đang Mượn':
        screen = DeviceBorrowingScreen(); // Replace with actual screen
        break;
      case 'Tra Cứu Lịch Sử Mượn':
        screen = DeviceHistoryScreen(); // Replace with actual screen
        break;
      default:
        screen = ManageDeviceScreen(); // Default
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
