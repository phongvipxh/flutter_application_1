import 'package:flutter/material.dart';
import 'data_storage.dart'; // Nhập file data_storage.dart
import 'device_detail_screen.dart';

class Device {
  String name;
  int id; // Mã thiết bị
  String info; // Thông tin
  String notes; // Ghi chú
  int total; // Tổng số lượng

  Device(this.id, this.name, this.info, this.notes, this.total);
}

class DeviceList {
  String listName;
  List<Device> devices;

  DeviceList(this.listName) : devices = [];
}

class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({Key? key}) : super(key: key);

  @override
  _DeviceListScreenState createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  List<DeviceList> deviceLists = [];

  @override
  void initState() {
    super.initState();
    _loadDeviceLists();
  }

  Future<void> _loadDeviceLists() async {
    final loadedLists = await DataStorage.loadDeviceLists();
    setState(() {
      deviceLists = loadedLists;
    });
  }

  Future<void> _addNewDeviceList(String name) async {
    setState(() {
      deviceLists.add(DeviceList(name));
    });
    await DataStorage.saveDeviceLists(deviceLists);
  }

  Future<void> _editDeviceList(int index, String newName) async {
    setState(() {
      deviceLists[index].listName = newName;
    });
    await DataStorage.saveDeviceLists(deviceLists);
  }

  Future<void> _deleteDeviceList(int index) async {
    setState(() {
      deviceLists.removeAt(index);
    });
    await DataStorage.saveDeviceLists(deviceLists);
  }

  void _showAddDeviceListDialog() {
    String newListName = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm danh sách thiết bị mới'),
          content: TextField(
            decoration: const InputDecoration(hintText: 'Tên danh sách'),
            onChanged: (value) {
              newListName = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Lưu'),
              onPressed: () {
                if (newListName.isNotEmpty) {
                  _addNewDeviceList(newListName);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDeviceListDialog(int index) {
    TextEditingController controller =
        TextEditingController(text: deviceLists[index].listName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sửa danh sách thiết bị'),
          content: TextField(
            decoration: const InputDecoration(hintText: 'Tên danh sách'),
            controller: controller,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Lưu'),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  _editDeviceList(index, controller.text);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDeviceListDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xoá danh sách thiết bị'),
          content: const Text('Bạn có chắc chắn muốn xoá danh sách này không?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Xoá'),
              onPressed: () {
                _deleteDeviceList(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeviceDetailsPage(int listIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceDetailsPage(
          deviceList: deviceLists[listIndex],
          onDeviceAdded: () {
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        title: const Text(
          'Danh sách thiết bị',
          style: TextStyle(
            fontWeight: FontWeight.w900, // Makes the text bold
            fontSize: 24, // Optional: Adjust the font size if needed
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.orange,
            onPressed: _showAddDeviceListDialog,
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: deviceLists.length,
            itemBuilder: (context, listIndex) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    deviceLists[listIndex].listName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    '${deviceLists[listIndex].devices.length} thiết bị',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditDeviceListDialog(listIndex);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteDeviceListDialog(listIndex);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    _showDeviceDetailsPage(listIndex);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class DeviceDetailsPage extends StatefulWidget {
  final DeviceList deviceList;
  final VoidCallback onDeviceAdded;

  const DeviceDetailsPage({
    Key? key,
    required this.deviceList,
    required this.onDeviceAdded,
  }) : super(key: key);

  @override
  _DeviceDetailsPageState createState() => _DeviceDetailsPageState();
}

class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
  String newDeviceName = '';

  // Thêm thiết bị mới
  void _addDevice() async {
    if (newDeviceName.isNotEmpty) {
      setState(() {
        // Generate a unique ID and set total as the current length of the device list
        int id = widget.deviceList.devices.length + 1; // Example ID generation
        int total = widget.deviceList.devices.length +
            1; // Assuming total is the count of devices
        widget.deviceList.devices
            .add(Device(id, newDeviceName, 'info', 'notes', total));
        newDeviceName = '';
      });
      await DataStorage.saveDeviceLists(
          [widget.deviceList]); // Lưu danh sách sau khi thêm thiết bị
      widget.onDeviceAdded(); // Gọi callback để cập nhật danh sách
    }
  }

  // Sửa thiết bị
  void _editDevice(int index, String newName) async {
    setState(() {
      widget.deviceList.devices[index].name = newName;
    });
    await DataStorage.saveDeviceLists(
        [widget.deviceList]); // Lưu danh sách sau khi sửa thiết bị
    widget.onDeviceAdded(); // Cập nhật lại danh sách
  }

  // Xóa thiết bị
  void _deleteDevice(int index) async {
    setState(() {
      widget.deviceList.devices.removeAt(index);
    });
    await DataStorage.saveDeviceLists(
        [widget.deviceList]); // Lưu danh sách sau khi xóa thiết bị
    widget.onDeviceAdded(); // Cập nhật lại danh sách
  }

  // Hiển thị hộp thoại sửa thiết bị
  void _showEditDeviceDialog(int index) {
    Device device = widget.deviceList.devices[index];
    TextEditingController nameController =
        TextEditingController(text: device.name);
    TextEditingController infoController =
        TextEditingController(text: device.info);
    TextEditingController notesController =
        TextEditingController(text: device.notes);
    TextEditingController totalController =
        TextEditingController(text: device.total.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sửa thiết bị'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name input
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Tên thiết bị',
                    border: OutlineInputBorder(),
                  ),
                  controller: nameController,
                ),
                const SizedBox(height: 10), // Spacer

                // Info input
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Thông tin thiết bị',
                    border: OutlineInputBorder(),
                  ),
                  controller: infoController,
                ),
                const SizedBox(height: 10), // Spacer

                // Total input (numbers only)
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Số lượng',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  controller: totalController,
                ),
                const SizedBox(height: 10), // Spacer

                // Notes input (larger field)
                TextFormField(
                  maxLines: 4, // Larger text field for notes
                  decoration: const InputDecoration(
                    labelText: 'Ghi chú',
                    border: OutlineInputBorder(),
                  ),
                  controller: notesController,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Lưu'),
              onPressed: () {
                setState(() {
                  device.name = nameController.text;
                  device.info = infoController.text;
                  device.notes = notesController.text;
                  device.total =
                      int.tryParse(totalController.text) ?? device.total;
                });
                DataStorage.saveDeviceLists([widget.deviceList]);
                widget.onDeviceAdded(); // Update the list
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Hiển thị hộp thoại xóa thiết bị
  void _showDeleteDeviceDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xoá thiết bị'),
          content: const Text('Bạn có chắc chắn muốn xoá thiết bị này không?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Xoá'),
              onPressed: () {
                _deleteDevice(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Hiển thị hộp thoại thêm thiết bị
  void _showAddDeviceDialog() {
    int newDeviceId = widget.deviceList.devices.length + 1;
    String newDeviceName = '';
    String newDeviceInfo = '';
    String newDeviceNotes = '';
    int newDeviceTotal = 1;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm thiết bị mới'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name input
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Tên thiết bị',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: (value) {
                    newDeviceName = value;
                  },
                ),
                const SizedBox(height: 10), // Spacer

                // Info input
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Thông tin thiết bị',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: (value) {
                    newDeviceInfo = value;
                  },
                ),
                const SizedBox(height: 10), // Spacer

                // Total input
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Số lượng',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    newDeviceTotal = int.tryParse(value) ?? 1;
                  },
                ),
                const SizedBox(height: 10), // Spacer

                // Notes input (larger field)
                TextFormField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Ghi chú',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: (value) {
                    newDeviceNotes = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Lưu'),
              onPressed: () {
                if (newDeviceName.isNotEmpty) {
                  setState(() {
                    widget.deviceList.devices.add(
                      Device(newDeviceId, newDeviceName, newDeviceInfo,
                          newDeviceNotes, newDeviceTotal),
                    );
                  });
                  DataStorage.saveDeviceLists([widget.deviceList]);
                  widget.onDeviceAdded(); // Update the list
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false, // Removes back button if needed
        title: Text(
          widget.deviceList.listName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24, // Larger, bold title
          ),
        ),
        backgroundColor: Colors.white,
        // centerTitle: true, // Center the title for a balanced look
        // backgroundColor: Colors.teal, // AppBar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding to the entire body
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.deviceList.devices.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3, // Card shadow for depth
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                    child: ListTile(
                      title: Text(
                        widget.deviceList.devices[index].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600, // Semi-bold text
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        'Mã: ${widget.deviceList.devices[index].id}',
                        style: TextStyle(
                          color:
                              Colors.grey[600], // Subtitle for additional info
                        ),
                      ),
                      onTap: () {
                        // Navigate to device detail screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DeviceDetailScreen(
                                device: widget.deviceList.devices[index]),
                          ),
                        );
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showEditDeviceDialog(index);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _showDeleteDeviceDialog(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDeviceDialog, // Trigger dialog to add device
        backgroundColor: Colors.teal, // Match the AppBar color
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Thêm thiết bị',
      ),
    );
  }
}
