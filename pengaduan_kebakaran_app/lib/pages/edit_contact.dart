import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pengaduan_kebakaran_app/API/api_connection.dart';
import 'package:pengaduan_kebakaran_app/theme/theme_color.dart';
import 'package:pengaduan_kebakaran_app/theme/theme_text.dart';
import 'dart:convert';

class EditContact extends StatefulWidget {
  @override
  _EditContactState createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _noTeleponController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  List contact = [];
  String? errorMessage;
  int? idContact;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      idContact = ModalRoute.of(context)?.settings.arguments as int?;
      _checkArgumentNull(idContact);
      getContactById(idContact);
    });
  }

  Future<void> _checkArgumentNull(int? idContact) async {
    if (idContact == null) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  Future<void> getContactById(int? idContact) async {
    String uri = API.readByIdContact;
    try {
      var response = await http
          .post(Uri.parse(uri), body: {'id_kontak': idContact.toString()});

      if (response.statusCode == 200) {
        setState(() {
          contact = jsonDecode(response.body);
          _noTeleponController.text = contact[0]['no_tlp'];
          _alamatController.text = contact[0]['alamat'];
        });
      } else {
        print('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateContact(
      int? idContact, String noTlp, String alamat) async {
    String uri = API.updateContact; // Sesuaikan URI dengan endpoint API Anda
    try {
      print(idContact);
      var response = await http.post(
        Uri.parse(uri),
        body: {
          'id_kontak': idContact.toString(),
          'no_tlp': noTlp,
          'alamat': alamat,
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
                  content: Text("Kontak berhasil diubah"),
                  actions: [
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, 'Contact');
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
    idContact = ModalRoute.of(context)?.settings.arguments as int?;
    return contact.isEmpty
        ? CircularProgressIndicator()
        : Scaffold(
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
                  borderRadius:
                      BorderRadius.circular(10), // BorderRadius untuk sudut
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        Text(
                          "Ubah Kontak",
                          style: TextStyle(fontSize: 30),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          // TAMPILKAN DATA NOMOR TELEPON SEBAGAI VALUE DISINI
                          controller: _noTeleponController,
                          decoration: InputDecoration(
                              labelText: 'Telephone Numbers',
                              hintText: 'Enter Your Telephone Numbers'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Telephone Numbers';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          // TAMPILKAN DATA ALAMAT SEBAGAI VALUE DISINI
                          controller: _alamatController,
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
                              updateContact(
                                idContact,
                                _noTeleponController.text,
                                _alamatController.text,
                              );
                            }
                          },
                          child: Text(
                            'Edit Contact',
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
