import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BorrowRequestForm extends StatefulWidget {
  final List<Map<String, dynamic>> students;
  final List<Map<String, dynamic>> devices;

  const BorrowRequestForm(
      {Key? key, required this.students, required this.devices})
      : super(key: key);

  @override
  _BorrowRequestFormState createState() => _BorrowRequestFormState();
}

class _BorrowRequestFormState extends State<BorrowRequestForm> {
  TextEditingController studentNameController = TextEditingController();
  DateTime returnDate = DateTime.now();
  String selectedStudentId = '';
  String selectedDevice = '';
  int quantity = 1;

  String? studentIdError;
  String? deviceError;
  String? quantityError;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Tạo yêu cầu mượn thiết bị",
          style: TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student ID Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Mã sinh viên",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                items: widget.students.map((student) {
                  return DropdownMenuItem<String>(
                    value: student['studentId'],
                    child: Text(student['studentId']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStudentId = value!;
                    // Auto-fill student name based on selected ID
                    final selectedStudent = widget.students
                        .firstWhere((student) => student['studentId'] == value);
                    studentNameController.text = selectedStudent['fullName'];
                    studentIdError = null;
                  });
                },
              ),
              SizedBox(height: 8),
              if (studentIdError != null)
                Text(studentIdError!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 16),

              // Auto-filled student name
              TextField(
                controller: studentNameController,
                decoration: InputDecoration(
                  labelText: "Tên sinh viên",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                readOnly: true,
              ),
              SizedBox(height: 16),

              // Date Picker for Return Date
              TextField(
                decoration: InputDecoration(
                  labelText: "Thời gian dự kiến trả",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: returnDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      returnDate = pickedDate;
                    });
                  }
                },
                controller: TextEditingController(
                  text: "${returnDate.toLocal()}".split(' ')[0],
                ),
              ),
              SizedBox(height: 16),

              // Device Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Tên thiết bị",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                items: widget.devices.map((device) {
                  return DropdownMenuItem<String>(
                    value: device['deviceId'],
                    child: Text(device['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDevice = value!;
                    deviceError = null;
                  });
                },
              ),
              SizedBox(height: 8),
              if (deviceError != null)
                Text(deviceError!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 16),

              // Quantity Input
              TextField(
                decoration: InputDecoration(
                  labelText: "Số lượng",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    quantity = int.tryParse(value) ?? 0;
                    quantityError = null;
                  });
                },
              ),
              SizedBox(height: 8),
              if (quantityError != null)
                Text(quantityError!, style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text("Hủy", style: TextStyle(color: Colors.red)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text("Mượn", style: TextStyle(color: Colors.orange)),
          onPressed: () {
            setState(() {
              studentIdError = selectedStudentId.isEmpty
                  ? "Vui lòng chọn mã sinh viên."
                  : null;
              deviceError =
                  selectedDevice.isEmpty ? "Vui lòng chọn tên thiết bị." : null;
              quantityError =
                  quantity <= 0 ? "Vui lòng nhập số lượng hợp lệ." : null;
            });

            if (studentIdError == null &&
                deviceError == null &&
                quantityError == null) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Yêu cầu mượn thành công!"),
              ));
            }
          },
        ),
      ],
    );
  }
}
