import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'devicelist_screen.dart';

// class DataStorage {
//   // Hàm lưu danh sách thiết bị vào SharedPreferences
//   static Future<void> saveDeviceLists(List<DeviceList> deviceLists) async {
//     final prefs = await SharedPreferences.getInstance();

//     // Mã hóa danh sách thiết bị thành chuỗi JSON
//     final String encodedData = jsonEncode(
//       deviceLists
//           .map((list) => {
//                 'listName': list.listName,
//                 'devices': list.devices
//                     .map((device) => {
//                           'id': device.id,
//                           'name': device.name,
//                           'info': device.info,
//                           'notes': device.notes,
//                           'total': device.total,
//                         })
//                     .toList(),
//               })
//           .toList(),
//     );

//     // Lưu chuỗi JSON vào SharedPreferences
//     await prefs.setString('deviceLists', encodedData);
//   }

//   // Hàm tải danh sách thiết bị từ SharedPreferences
//   static Future<List<DeviceList>> loadDeviceLists() async {
//     final prefs = await SharedPreferences.getInstance();

//     // Lấy dữ liệu được lưu trữ dưới dạng chuỗi JSON
//     final String? encodedData = prefs.getString('deviceLists');

//     // Nếu không có dữ liệu thì trả về danh sách rỗng
//     if (encodedData == null) {
//       return [];
//     }

//     // Giải mã dữ liệu từ JSON
//     final List<dynamic> decodedData = jsonDecode(encodedData);

//     // Chuyển đổi dữ liệu JSON thành danh sách đối tượng DeviceList
//     return decodedData.map((list) {
//       final deviceList = DeviceList(list['listName']);
//       deviceList.devices = (list['devices'] as List<dynamic>).map((deviceData) {
//         // Create a Device instance using all necessary parameters
//         return Device(
//           deviceData['id'] as int,
//           deviceData['name'],
//           deviceData['info'],
//           deviceData['notes'],
//           deviceData['total'],
//         );
//       }).toList();
//       return deviceList;
//     }).toList();
//   }
// }

class DeviceStorage {
  static List<Map<String, dynamic>> devices = [
    {
      "deviceId": "001",
      "type": "Laptop",
      "name": "Dell XPS 13",
      "totalQuantity": 10,
      "borrowed": 2,
      "available": 8,
    },
    {
      "deviceId": "002",
      "type": "Projector",
      "name": "Epson EB-X41",
      "totalQuantity": 5,
      "borrowed": 1,
      "available": 4,
    },
    {
      "deviceId": "003",
      "type": "Tablet",
      "name": "iPad Pro 11",
      "totalQuantity": 7,
      "borrowed": 3,
      "available": 4,
    },
    {
      "deviceId": "004",
      "type": "Smartphone",
      "name": "Samsung Galaxy S21",
      "totalQuantity": 15,
      "borrowed": 5,
      "available": 10,
    },
    {
      "deviceId": "005",
      "type": "Printer",
      "name": "HP LaserJet Pro M15",
      "totalQuantity": 3,
      "borrowed": 1,
      "available": 2,
    },
    {
      "deviceId": "006",
      "type": "Monitor",
      "name": "LG UltraWide 29",
      "totalQuantity": 8,
      "borrowed": 2,
      "available": 6,
    },
    {
      "deviceId": "007",
      "type": "Headphones",
      "name": "Sony WH-1000XM4",
      "totalQuantity": 12,
      "borrowed": 4,
      "available": 8,
    },
    {
      "deviceId": "008",
      "type": "Webcam",
      "name": "Logitech C920",
      "totalQuantity": 5,
      "borrowed": 1,
      "available": 4,
    },
    {
      "deviceId": "009",
      "type": "External Hard Drive",
      "name": "Seagate Backup Plus 2TB",
      "totalQuantity": 6,
      "borrowed": 2,
      "available": 4,
    },
    {
      "deviceId": "010",
      "type": "Router",
      "name": "TP-Link Archer A7",
      "totalQuantity": 4,
      "borrowed": 1,
      "available": 3,
    },
  ];
  // Danh sách lưu trữ yêu cầu mượn
  static List<Map<String, dynamic>> borrowRequests = [];

  // Biến để theo dõi mã phiếu mượn hiện tại
  static int RequestId = 0;

  // Hàm tạo mã phiếu mượn
  static String generateRequestId() {
    RequestId++; // Tăng mã phiếu mượn lên 1
    return '$RequestId'; // Định dạng mã phiếu mượn
  }
}
