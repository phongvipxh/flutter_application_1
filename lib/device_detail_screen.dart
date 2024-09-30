import 'package:flutter/material.dart';
import 'devicelist_screen.dart'; // Import your device list screen

class DeviceDetailScreen extends StatelessWidget {
  final Device device;

  DeviceDetailScreen({required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          device.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _showEditDeviceDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                    Icons.device_hub, 'Mã thiết bị', device.id.toString()),
                _buildDetailRow(
                    Icons.device_unknown, 'Tên thiết bị', device.name),
                _buildDetailRow(Icons.info, 'Thông tin', device.info),
                _buildDetailRow(Icons.format_list_numbered, 'Tổng số lượng',
                    device.total.toString()),
                _buildDetailRowWithHeight(Icons.note, 'Ghi chú', device.notes,
                    2), // Increased height for notes
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 12.0), // Even vertical spacing
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100], // Light background for clarity
          borderRadius: BorderRadius.circular(10), // Rounded corners
          border:
              Border.all(color: Colors.grey.withOpacity(0.5)), // Subtle border
        ),
        padding: const EdgeInsets.all(12.0), // Inner padding for better spacing
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.orangeAccent), // Icon for better visual
            SizedBox(width: 10), // Space between icon and label
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$label:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black, // Set label color to black
                    ),
                  ),
                  SizedBox(height: 4), // Space between label and value
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black, // Set value color to black
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // New method to build the detail row with increased height for notes
  Widget _buildDetailRowWithHeight(
      IconData icon, String label, String value, double heightFactor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100], // Light background for clarity
          borderRadius: BorderRadius.circular(10), // Rounded corners
          border:
              Border.all(color: Colors.grey.withOpacity(0.5)), // Subtle border
        ),
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.orangeAccent), // Icon for better visual
            SizedBox(width: 10), // Space between icon and label
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$label:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black, // Set label color to black
                    ),
                  ),
                  SizedBox(height: 4), // Space between label and value
                  Container(
                    height: 40 * heightFactor, // Increased height for notes
                    child: SingleChildScrollView(
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black, // Set value color to black
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDeviceDialog(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: device.name);
    final TextEditingController infoController =
        TextEditingController(text: device.info);
    final TextEditingController totalController =
        TextEditingController(text: device.total.toString());
    final TextEditingController notesController =
        TextEditingController(text: device.notes);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15.0), // Rounded corners for dialog
          ),
          title: Text('Sửa thiết bị',
              style: TextStyle(
                  color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                _buildTextField(nameController, 'Tên thiết bị'),
                _buildTextField(infoController, 'Thông tin'),
                _buildTextField(totalController, 'Tổng số lượng',
                    isNumber: true),
                _buildTextField(notesController, 'Ghi chú',
                    isMultiline: true), // Pass isMultiline as true
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Hủy', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Lưu', style: TextStyle(color: Colors.orangeAccent)),
              onPressed: () {
                _updateDevice(
                  nameController.text,
                  infoController.text,
                  int.tryParse(totalController.text) ?? 0,
                  notesController.text,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false, bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey), // Label color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
            borderSide: BorderSide(color: Colors.orangeAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.orangeAccent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: isMultiline ? 5 : 1, // Increase lines for multiline
        minLines: isMultiline ? 3 : 1, // Minimum lines for multiline
      ),
    );
  }

  void _updateDevice(String name, String info, int total, String notes) {
    device.name = name;
    device.info = info;
    device.total = total;
    device.notes = notes;
  }
}
