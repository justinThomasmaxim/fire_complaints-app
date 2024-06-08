import 'package:flutter/material.dart';
import 'package:pengaduan_kebakaran_app/theme/theme_color.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pengaduan_kebakaran_app/API/api_connection.dart';

class TentangAplikasi extends StatefulWidget {
  @override
  State<TentangAplikasi> createState() => _TentangAplikasiState();
}

class _TentangAplikasiState extends State<TentangAplikasi> {
  TextEditingController _textController = TextEditingController();
  List deskripsi = [];
  String textData = '';
  int? userId;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userId = ModalRoute.of(context)?.settings.arguments as int?;
      _checkUserNull(userId);
      _checkIfUser(userId);
      getInfoAplikasi();
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

  Future<void> getInfoAplikasi() async {
    String uri = API.readInfoAplikasi;
    try {
      var response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        setState(() {
          deskripsi = jsonDecode(response.body);
          textData = deskripsi[0]['deskripsi'];
          _textController.text = textData;
        });
      } else {
        print('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> addInfoAplikasi(String deskripsi) async {
    String uri =
        API.createInfoAplikasi; // Sesuaikan URI dengan endpoint API Anda
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: {
          'deskripsi': deskripsi, // Ganti dengan id_pengguna yang sesuai
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
                  content: Text("Tentang Aplikasi berhasil ditambahkan"),
                  actions: [
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(
                            context, 'TentangAplikasi');
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

  Future<void> updateInfoAplikasi(String deskripsi) async {
    String uri =
        API.updateInfoAplikasi; // Sesuaikan URI dengan endpoint API Anda
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: {
          'deskripsi': deskripsi, // Ganti dengan id_pengguna yang sesuai
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
                  content: Text("Tentang Aplikasi berhasil diubah"),
                  actions: [
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(
                            context, 'TentangAplikasi');
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

  Future<void> deleteInfoAplikasi(String deskripsi) async {
    String uri =
        API.deleteInfoAplikasi; // Sesuaikan URI dengan endpoint API Anda
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: {
          'deskripsi': deskripsi, // Ganti dengan id_pengguna yang sesuai
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
                  content: Text("Tentang Aplikasi berhasil dihapus"),
                  actions: [
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(
                            context, 'TentangAplikasi');
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
          margin:
              EdgeInsets.all(8), // Margin untuk mengurangi ukuran background
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ThemeColor.dark, // Warna background hitam
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: ThemeColor.whiteColor),
            onPressed: () {
              Navigator.pop(context); // Kembali ke halaman sebelumnya
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info, color: ThemeColor.dark),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: ThemeColor.dark, // Warna background kontainer
                borderRadius:
                    BorderRadius.circular(10), // BorderRadius untuk sudut
              ),
              child: Text(
                "Tentang Aplikasi",
                style: TextStyle(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 420,
            margin: EdgeInsets.only(left: 40, right: 40),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ThemeColor.darkColor, // Warna background kontainer
              borderRadius:
                  BorderRadius.circular(10), // BorderRadius untuk sudut
              // border: Border.all(color: Colors.black)
            ),
            child: Column(
              children: [
                Container(
                  height: 260,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: ThemeColor.darkColor, // Warna background kontainer
                    borderRadius:
                        BorderRadius.circular(10), // BorderRadius untuk sudut
                    // border: Border.all(color: Colors.black)
                  ),
                  child: SingleChildScrollView(
                    child: TextField(
                      controller: _textController,
                      maxLines: 30,
                      decoration: InputDecoration(
                        hintText: textData.isEmpty
                            ? "Isi tentang Aplikasi"
                            : textData,
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
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
                      if (textData.isEmpty || textData == '')
                        InkWell(
                          onTap: () {
                            setState(() {
                              // textData = _textController.text;
                              // _textController.clear();
                              setState(() {
                                addInfoAplikasi(_textController.text);
                              });
                            });
                          },
                          child: CircleAvatar(
                            // TAMBAHKAN WIDGET UNTUK DAPAT MENEKAN TOMBOL
                            radius: 20, // Ukuran lingkaran
                            backgroundColor:
                                ThemeColor.dark, // Warna background hitam
                            child: Icon(
                              Icons.add,
                              color: ThemeColor.whiteColor,
                            ),
                          ),
                        ),
                      if (textData.isNotEmpty)
                        InkWell(
                          onTap: () {
                            setState(() {
                              deleteInfoAplikasi(_textController.text);
                            });
                          },
                          child: Icon(
                            Icons.delete,
                            color: ThemeColor.whiteColor,
                          ),
                        ),
                      SizedBox(
                        width: 10,
                      ),
                      if (textData.isNotEmpty)
                        InkWell(
                          onTap: () {
                            setState(() {
                              updateInfoAplikasi(_textController.text);
                            });
                          },
                          child: Icon(
                            Icons.edit,
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
