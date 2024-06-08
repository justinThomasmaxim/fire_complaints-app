import 'package:flutter/material.dart';
import 'package:pengaduan_kebakaran_app/theme/theme_color.dart';
import 'package:pengaduan_kebakaran_app/theme/theme_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pengaduan_kebakaran_app/API/api_connection.dart';

class Contact extends StatefulWidget {
  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  List contacts = [];
  int? userId;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userId = ModalRoute.of(context)?.settings.arguments as int?;
      _checkUserNull(userId);
      _checkIfUser(userId);
      getContact();
    });
  }

  Future<void> _checkIfUser(int? userId) async {
    if (userId == 1) {
      setState(() {
        isAdmin = false;
      });
    } else {
      setState(() {
        isAdmin = true;
      });
    }
  }

  Future<void> _checkUserNull(int? userId) async {
    if (userId == null) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  Future<void> getContact() async {
    String uri = API.readContact;
    try {
      var response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        setState(() {
          contacts = jsonDecode(response.body);
        });
      } else {
        print('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deleteAllContact() async {
    String uri = API.deleteAllContact; // Sesuaikan URI dengan endpoint API Anda
    try {
      var response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success']) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Success"),
                  content: Text("Semua kontak berhasil dihapus"),
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

  Future<void> deleteByIdContact(int idContact) async {
    String uri = API.deleteByIdContact; // Sesuaikan URI dengan endpoint API Anda
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: {
          'id_kontak': idContact.toString()
        }
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success']) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Success"),
                  content: Text("Kontak berhasil dihapus"),
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
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: ThemeColor.dark),
            onPressed: () {
              // Add logic for call action
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: ThemeColor.dark,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Contact",
                style: TextStyle(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 460,
            width: 320,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ThemeColor.darkColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  height: 320,
                  width: 320,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: ThemeColor.darkColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(contacts.length, (index) {
                        return Column(
                          children: [
                            contacts.isEmpty
                                ? Row(
                                    children: [
                                      Text("Tidak ada kontak yang tersedia"),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            color: ThemeColor.dark),
                                        child: Text(
                                          "${index + 1}",
                                          style: ThemeTextStyle().textWhite,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        contacts[index]['no_tlp'],
                                        style: ThemeTextStyle().textBlack,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        contacts[index]['alamat'],
                                        style: ThemeTextStyle().textBlack,
                                      ),
                                      Spacer(),
                                      if (!isAdmin)
                                        InkWell(
                                          onTap: () {
                                            int idContact = int.parse(
                                                contacts[index]['id_kontak']);
                                            setState(() {
                                              deleteByIdContact(idContact);
                                            });
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: ThemeColor.whiteColor,
                                            size: 16,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      if (!isAdmin)
                                        InkWell(
                                          onTap: () {
                                            int idContact = int.parse(
                                                contacts[index]['id_kontak']);
                                            Navigator.pushReplacementNamed(
                                                context, 'EditContact',
                                                arguments: idContact);
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: ThemeColor.whiteColor,
                                            size: 16,
                                          ),
                                      ),
                                    ],
                                  ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (!isAdmin)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, 'AddContact',
                              arguments: userId);
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: ThemeColor.dark,
                          child: Icon(
                            Icons.add,
                            color: ThemeColor.whiteColor,
                          ),
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            deleteAllContact();
                          });
                        },
                        child: Icon(
                          Icons.delete,
                          color: ThemeColor.whiteColor,
                        ),
                      ),
                    ],
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
