import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonEncode and jsonDecode
import 'package:flutter_application_1/main.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Thêm thư viện SharedPreferences

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false; // Biến lưu trạng thái ghi nhớ

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials(); // Tải thông tin đã lưu khi khởi động
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    final password = prefs.getString('password') ?? '';
    final rememberMe = prefs.getBool('rememberMe') ?? false;

    setState(() {
      _emailController.text = email;
      _passwordController.text = password;
      _rememberMe = rememberMe;
    });
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('email', _emailController.text);
      await prefs.setString('password', _passwordController.text);
      await prefs.setBool('rememberMe', true);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.setBool('rememberMe', false);
    }
  }

// Hàm để lưu access_token
  Future<void> saveAccessToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'access_token', token); // Lưu token với key 'access_token'
  }

// Hàm để lấy access_token đã lưu
  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs
        .getString('access_token'); // Truy xuất token với key 'access_token'
  }

  //   print access token

  Future<void> login() async {
    final url = Uri.parse(
        'https://sos-vanthuc-backend-bl1m.onrender.com/api/auth/login');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'accept': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        // If login is successful
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String accessToken = responseData['access_token'];

        await saveAccessToken(accessToken);
        // Lưu thông tin đăng nhập nếu "Ghi nhớ đăng nhập" được chọn
        await _saveCredentials();

        // Check if the widget is still mounted before navigating
        if (!mounted) return;

        // Navigate to the next screen after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      } else {
        // If the server returns an error
        print('Login failed: ${response.body}');

        // Check if the widget is still mounted before showing snackbar
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Login failed! Please check your credentials.')),
        );
      }
    } catch (error) {
      print('Error: $error');

      // Check if the widget is still mounted before showing snackbar
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Đặt thành false để tránh tràn
      body: Container(
        width: double.infinity,
        height: double.infinity, // Đảm bảo chiều cao là vô hạn
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 60), // Thêm khoảng cách 60px từ trên xuống
            Container(
              height: 310,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0, bottom: 0),
                    child: Image.network(
                      'https://phenikaa-uni.top/assets/logo_Phenikaa-dW02tada.png',
                      width: 450,
                      height: 310,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),

                  // Email input
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Tài khoản',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 229, 231, 235),
                          width: 2.0,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Password input
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 229, 231, 235),
                          width: 5.0,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),

                  // Remember Me button
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                        activeColor: Colors.white, // Màu checkbox khi được chọn
                        checkColor: Colors.black, // Màu dấu kiểm
                        side: BorderSide(
                            color: Colors.white), // Viền checkbox màu trắng
                      ),
                      Text(
                        'Ghi nhớ đăng nhập',
                        style: TextStyle(color: Colors.white), // Màu chữ trắng
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: login, // Call login function on button press
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 242, 101, 38),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Đăng nhập',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
