import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pengaduan_kebakaran_app/API/api_connection.dart';
import 'package:pengaduan_kebakaran_app/theme/theme_color.dart';
import 'package:pengaduan_kebakaran_app/theme/theme_text.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  String? errorMessage;

  Future<void> getPenggunaByUserAndPass(
      String username, String password) async {
    String uri = API.readPengguna; // Sesuaikan URI dengan endpoint API Anda
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true) {
          var userId = jsonResponse['id_pengguna'];
          if (userId != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setInt('id_pengguna', int.parse(userId));
            print("User ID = " + userId);

            Navigator.pushReplacementNamed(context, '/');
          } else {
            setState(() {
              errorMessage = 'Invalid user ID';
            });
          }
        } else {
          setState(() {
            errorMessage = jsonResponse['message'] ?? 'Unknown error occurred';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load data: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.backgroundApp,
      appBar: AppBar(
        backgroundColor: ThemeColor.backgroundApp,
        title: Center(
          child: Image.asset(
            "images/logo_aplikasi.png",
            height: 200,
            width: 200,
          ),
        ),
      ),
      body: Center(
        child: Container(
          height: 400,
          margin: EdgeInsets.only(left: 40, right: 40),
          decoration: BoxDecoration(
            color: ThemeColor.darkColor, // Warna background kontainer
            borderRadius: BorderRadius.circular(10), // BorderRadius untuk sudut
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter Your Username',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter Your Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_passwordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32),
                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        getPenggunaByUserAndPass(
                          _usernameController.text,
                          _passwordController.text,
                        );
                      }
                    },
                    child: Text(
                      'Login',
                      style: ThemeTextStyle().textWhite,
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColor.dark),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'SignIn');
                    },
                    child: Text('Don\'t have an account? Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
