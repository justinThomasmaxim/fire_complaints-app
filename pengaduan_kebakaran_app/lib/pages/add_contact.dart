import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pengaduan_kebakaran_app/API/api_connection.dart';
import 'package:pengaduan_kebakaran_app/theme/theme_color.dart';
import 'package:pengaduan_kebakaran_app/theme/theme_text.dart';
import 'dart:convert';

class AddContact extends StatefulWidget {
  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _noTeleponController = TextEditingController();
  final TextEditingController _alamatController    = TextEditingController();
  String? errorMessage;
   int? userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userId = ModalRoute.of(context)?.settings.arguments as int?;
      _checkUserNull(userId);
    });
  }

  Future<void> _checkUserNull(int? userId) async {
    if (userId == null) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  Future<void> addContact(int? userId, String noTlp, String alamat) async {
    String uri =
        API.createContact; // Sesuaikan URI dengan endpoint API Anda
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: {
          'id_pengguna' : userId.toString(),
          'no_tlp'      : noTlp, 
          'alamat'      : alamat, 
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
                  content: Text("Kontak berhasil ditambahkan"),
                  actions: [
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(
                            context, 'Contact');
                      },
                      child: Text("Oke"),
                    )
                  ],
                );
              });
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
    userId = ModalRoute.of(context)?.settings.arguments as int?;
    return Scaffold(
      backgroundColor: ThemeColor.backgroundApp,
      appBar: AppBar(
        backgroundColor: ThemeColor.backgroundApp,
        leading: Container(
          width: 20,
          height: 20,
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ThemeColor.dark,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: ThemeColor.whiteColor),
            onPressed: () {
              Navigator.pop(context);
            },
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
                    "Tambah Kontak",
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _alamatController   ,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      hintText: 'Enter Your Address',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Address';
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
                        addContact(
                          userId,
                          _noTeleponController.text,
                          _alamatController.text,
                        );
                      }
                    },
                    child: Text(
                      'Add Contact',
                      style: ThemeTextStyle().textWhite,
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColor.dark),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
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
