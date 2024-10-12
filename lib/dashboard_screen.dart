import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/devicelist_screen.dart';
// Import other necessary screens here
// import 'package:flutter_application_1/manage_borrowed_device_screen.dart';
// import 'package:flutter_application_1/manage_room_screen.dart';
import 'package:flutter_application_1/account_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hệ thống quản lý thiết bị",
          style: TextStyle(
            fontWeight: FontWeight.w900, // Makes the text bold
            fontSize: 24, // Optional: Adjust the font size if needed
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              width: double.infinity,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Your existing widgets go here

                    Container(
                      width: double.infinity,
                      height: 150,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 0),
                            child: Text(
                              'Tổng quan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _buildItem('Tổng số thiết bị :', Colors.blue,
                                    Icons.devices, '100'),
                                _buildItem('Đã cho mượn :', Colors.green,
                                    Icons.check_circle, '20'),
                                _buildItem('Sẵn sàng :', Colors.orange,
                                    Icons.check, '75'),
                                _buildItem('Đang bảo trì :', Colors.red,
                                    Icons.build, '5'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, bottom: 10),
                      child: Container(
                        width: double.infinity,
                        height: 250,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 0, bottom: 5),
                              child: Text(
                                'Danh sách thiết bị đang mượn theo trạng thái',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          const Color.fromARGB(115, 177, 0, 0)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    // Chú thích bên trái
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        LegendItem(
                                            color: Colors.orange,
                                            text: 'Sẵn sàng'),
                                        SizedBox(height: 10),
                                        LegendItem(
                                            color: Colors.green,
                                            text: 'Đã cho mượn'),
                                        SizedBox(height: 10),
                                        LegendItem(
                                            color: Colors.red,
                                            text: 'Đang bảo trì'),
                                      ],
                                    ),
                                    SizedBox(
                                        width:
                                            20), // Khoảng cách giữa chú thích và biểu đồ
                                    // Biểu đồ tròn bên phải
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        child: PieChart(
                                          PieChartData(
                                            sections: showingSections(),
                                            borderData:
                                                FlBorderData(show: false),
                                            centerSpaceRadius: 40,
                                            startDegreeOffset: 0,
                                          ),
                                          swapAnimationDuration:
                                              Duration(milliseconds: 150),
                                          swapAnimationCurve: Curves.linear,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        width: 388,
                        height: 372,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5, top: 10),
                              child: Text(
                                "Danh sách phòng sẵn sàng cho mượn",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: PaginatedDataTable(
                                columns: [
                                  DataColumn(
                                      label: Expanded(
                                          child: Text(
                                    'Vị trí',
                                    textAlign: TextAlign.center,
                                  ))),
                                  DataColumn(
                                      label: Expanded(
                                          child: Text(
                                    'Mã phòng',
                                    textAlign: TextAlign.center,
                                  ))),
                                  DataColumn(
                                      label: Expanded(
                                          child: Text(
                                    'Chi tiết',
                                    textAlign: TextAlign.center,
                                  ))),
                                ],
                                source: MyDataTableSource(context),
                                columnSpacing: 90,
                                rowsPerPage: 5,
                                dataRowHeight: 45,
                                headingRowHeight: 45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //     items: const <BottomNavigationBarItem>[
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.dashboard),
      //         label: 'Dashboard',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.devices),
      //         label: 'Danh sách thiết bị',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.assignment),
      //         label: 'Quản lý mượn thiết bị',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.room),
      //         label: 'Quản lý mượn phòng',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.account_circle),
      //         label: 'Tài khoản',
      //       ),
      //     ],
      //     currentIndex: _selectedIndex,
      //     selectedItemColor: Colors.amber[800],
      //     onTap: (int index) {
      //       Widget selectedScreen;

      //       // Determine which screen to navigate to based on the selected index
      //       switch (index) {
      //         case 0:
      //           selectedScreen = DashboardScreen();
      //           break;
      //         case 1:
      //           selectedScreen = DeviceListScreen();
      //           break;
      //         case 2:
      //           // Replace with your screen for "Quản lý mượn thiết bị"
      //           // selectedScreen = ManageBorrowedDeviceScreen();
      //           selectedScreen = Container();
      //           break;
      //         case 3:
      //           // Replace with your screen for "Quản lý mượn phòng"
      //           // selectedScreen = ManageRoomScreen();
      //           selectedScreen = Container();
      //           break;
      //         case 4:
      //           // Replace with your screen for "Tài khoản"
      //           selectedScreen = AccountScreen();
      //           break;
      //         default:
      //           selectedScreen = DashboardScreen();
      //       }

      //       // Update the selected index and replace the current screen with the selected one
      //       setState(() {
      //         _selectedIndex = index; // Update the selected index
      //       });

      //       // Use Navigator to replace the current screen with the selected screen
      //       Navigator.pushReplacement(
      //         context,
      //         PageRouteBuilder(
      //           pageBuilder: (context, animation, secondaryAnimation) =>
      //               selectedScreen,
      //           transitionsBuilder:
      //               (context, animation, secondaryAnimation, child) {
      //             const begin = Offset(1.0, 0.0); // Slide from right
      //             const end = Offset.zero;
      //             const curve = Curves.ease;

      //             var tween = Tween(begin: begin, end: end)
      //                 .chain(CurveTween(curve: curve));
      //             var offsetAnimation = animation.drive(tween);

      //             return SlideTransition(
      //               position: offsetAnimation,
      //               child: child,
      //             );
      //           },
      //         ),
      //       );
      //     }),
    );
  }

  Widget _buildItem(String title, Color color, IconData icon, String quantity) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: 10, bottom: 10, top: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        height: 150,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      quantity,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (index) {
      switch (index) {
        case 0:
          return PieChartSectionData(
              color: Colors.red,
              value: 5,
              title: '5%',
              radius: 60,
              titleStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ));
        case 1:
          return PieChartSectionData(
              color: Colors.green,
              value: 20,
              title: '20%',
              radius: 60,
              titleStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ));
        case 2:
          return PieChartSectionData(
              color: Colors.orange,
              value: 75,
              title: '75%',
              radius: 60,
              titleStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ));
        default:
          throw Error();
      }
    });
  }
}

class MyDataTableSource extends DataTableSource {
  final List<Map<String, String>> _data = List.generate(20, (index) {
    return {
      "Vị trí": "Vị trí ${index + 1}",
      "Mã phòng": "MP${index + 1}",
      "Quản lý": "QL${index + 1}",
      "Ghi chú": "Ghi chú ${index + 1}",
    };
  });

  final BuildContext parentContext;

  MyDataTableSource(this.parentContext);

  @override
  DataRow getRow(int index) {
    if (index >= _data.length) {
      throw Exception("Index out of range");
    }
    final rowData = _data[index];
    return DataRow(cells: [
      DataCell(Text(rowData["Vị trí"]!)),
      DataCell(Text(rowData["Mã phòng"]!)),
      DataCell(
        TextButton(
          onPressed: () => _showDetails(rowData),
          child: Text("Chi tiết"),
        ),
      ),
    ]);
  }

  void _showDetails(Map<String, String> rowData) {
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Chi tiết thông tin"),
          content: Text(
            "Vị trí: ${rowData["Vị trí"]}\nMã phòng: ${rowData["Mã phòng"]}\nQuản lý: ${rowData["Quản lý"]}\nGhi chú: ${rowData["Ghi chú"]}",
          ),
          actions: [
            TextButton(
              child: Text("Đóng"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 15,
          height: 15,
          color: color,
        ),
        SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
