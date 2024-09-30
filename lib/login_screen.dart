import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 0, 0, 0),
              const Color.fromARGB(255, 0, 79, 143)
            ],
            stops: [0.1, 1],
            begin: AlignmentDirectional(1, -1),
            end: AlignmentDirectional(-1, 1),
          ),
        ),
        alignment: AlignmentDirectional(0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 310,
              width: double.infinity,
              decoration: BoxDecoration(
                  // color: const Color.fromARGB(255, 0, 0, 0),
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0, bottom: 0),
                    child: Image.network(
                      'https://phenikaa-uni.top/assets/logo_Phenikaa-dW02tada.png', // Thay thế bằng link logo của bạn
                      width: 450, // Điều chỉnh kích thước logo
                      height: 310,
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 20),
                  //   child: Text(
                  //     'Hệ thống quản lý thiết bị',
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       color: Colors.black,
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 210,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  SizedBox(height: 30), // Khoảng cách giữa title và input

                  // Input Tài khoản
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Tài khoản',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // Bo góc input
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 229, 231, 235), // Màu viền
                          width: 2.0, // Độ dày của viền
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white, // Màu nền trắng
                      prefixIcon: Icon(Icons.person), // Thêm icon tài khoản
                    ),
                  ),
                  SizedBox(height: 20), // Khoảng cách giữa 2 input

                  // Input Mật khẩu
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // Bo góc input
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 229, 231, 235), // Màu viền
                          width: 5.0, // Độ dày của viền
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white, // Màu nền trắng
                      prefixIcon: Icon(Icons.lock), // Thêm icon mật khẩu
                    ),
                    obscureText: true, // Ẩn ký tự mật khẩu
                  ),
                ],
              ),
            ),
            // Đây là Container riêng cho Button Login
            Container(
              width: double.infinity, // Để button chiếm toàn bộ chiều ngang
              padding:
                  EdgeInsets.symmetric(horizontal: 20), // Tùy chỉnh khoảng cách
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý sự kiện khi nhấn nút
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(
                      255, 242, 101, 38), // Màu nền rgb(111, 97, 239)
                  padding:
                      EdgeInsets.symmetric(vertical: 15), // Độ cao của button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Bo góc button
                  ),
                ),
                child: Text(
                  'Đăng nhập',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white, // Màu chữ
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
