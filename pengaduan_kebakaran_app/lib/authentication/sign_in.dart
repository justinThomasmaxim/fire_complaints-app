import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pengaduan_kebakaran_app/API/api_connection.dart';
import 'package:pengaduan_kebakaran_app/theme/theme_color.dart';
import 'package:pengaduan_kebakaran_app/theme/theme_text.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _noTeleponController  = TextEditingController();
  final TextEditingController _usernameController   = TextEditingController();
  final TextEditingController _passwordController   = TextEditingController();
  final TextEditingController _namaController       = TextEditingController();
  bool _passwordVisible = false;

  Future<void> addPengguna(String username, String password, String nama, String noTlp) async {
    String uri = API.createPengguna; // Sesuaikan URI dengan endpoint API Anda
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: {
          'username': username,
          'password': password,
          'nama'    : nama,
          'no_tlp'  : noTlp
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success']) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Success"),
                content: Text("Sign In Berhasil"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(context, "Login");
                    },
                    child: Text("Oke"),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Gagal"),
                content: Text("Gagal Sign In"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Oke"),
                  ),
                ],
              );
            },
          );
        }
      } else {
        print('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
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
           height: 460,
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
                  Text("Sign In" ,style: TextStyle(fontSize: 30),),
                  SizedBox(height: 5,),
                  TextFormField(
                    controller: _noTeleponController,
                    decoration: InputDecoration(
                      labelText: 'Telephone Numbers',
                      hintText: 'Enter Your Telephone Numbers',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Telephone Numbers';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 5,),
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
                  SizedBox(height: 5,),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter Your Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible ? Icons.visibility : Icons.visibility_off,
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
                  SizedBox(height: 5,),
                  TextFormField(
                    controller: _namaController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter Your Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15,),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          addPengguna(
                            _usernameController.text,
                            _passwordController.text,
                            _namaController.text,
                            _noTeleponController.text,
                          );
                        });
                      }
                    },
                    child: Text('Sign In', style: ThemeTextStyle().textWhite,),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColor.dark
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'Login');
                    },
                    child: Text('Already have an account? Login'),
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