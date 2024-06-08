import 'package:flutter/material.dart';
import 'package:pengaduan_kebakaran_app/theme/theme_color.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:pengaduan_kebakaran_app/API/api_connection.dart';
import 'package:pengaduan_kebakaran_app/theme/theme_text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:path/path.dart' as path;

class Pengaduan extends StatefulWidget {
  @override
  State<Pengaduan> createState() => _PengaduanState();
}

class _PengaduanState extends State<Pengaduan> {
  TextEditingController _textController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  List dataPengaduan = [];
  String alamat = '';
  String textData = '';
  int? userId;
  bool isAdmin = false;
  // io.File? _imageFile;
  String? _imageUrl;
  String? _fileName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userId = ModalRoute.of(context)?.settings.arguments as int?;
      _checkUserNull(userId);
      _checkIfUser(userId);
      getPengaduan(userId);
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
      CircularProgressIndicator();
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  Future<void> getPengaduan(int? userId) async {
    String uri = API.readPengaduan;
    try {
      var response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        setState(() {
          dataPengaduan = jsonDecode(response.body);
          _fileName = dataPengaduan[0]['image_path'];
          alamat = dataPengaduan[0]['alamat'];
          _alamatController.text = alamat;
          textData = dataPengaduan[0]['deskripsi'];
          _textController.text = textData;
        });
      } else {
        print('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> addPengaduan(
      int? userId, String alamat, String deskripsi, String? imagePath) async {
    String uri = API.createPengaduan; // Sesuaikan URI dengan endpoint API Anda
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: {
          'id_pengguna': userId.toString(),
          'alamat': alamat,
          'deskripsi': deskripsi,
          'image_path': imagePath,
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
                  content: Text("Pengaduan berhasil ditambahkan"),
                  actions: [
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, 'Pengaduan');
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

  Future<void> updatePengaduan(
      String alamat, String deskripsi, String? imagePath) async {
    String uri = API.updatePengaduan; // Sesuaikan URI dengan endpoint API Anda
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: {
          'alamat': alamat,
          'deskripsi': deskripsi,
          'image_path': imagePath,
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
                  content: Text("Pengaduan berhasil diubah"),
                  actions: [
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, 'Pengaduan');
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

  Future<void> deletePengaduan() async {
    String uri = API.deletePengaduan; // Sesuaikan URI dengan endpoint API Anda
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
                  content: Text("Pengaduan berhasil dihapus"),
                  actions: [
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, 'Pengaduan');
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

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        if (kIsWeb) {
          _imageUrl = pickedFile.path;
          print(_imageUrl);
          setState(() {
            // _fileName = path.basename(pickedFile.path);
            _fileName = pickedFile.name;
            print(_fileName);
          });
        }
        // else {
        //   _imageFile = io.File(pickedFile.path);
        //   print(_imageFile);
        // }
      }
    });
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
      body: SingleChildScrollView(
        child: Column(
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
                  "Pengaduan",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 85,
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
                    height: 40,
                    width: 320,
                    padding: EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                      color: ThemeColor.darkColor, // Warna background kontainer
                      borderRadius:
                          BorderRadius.circular(10), // BorderRadius untuk sudut
                      // border: Border.all(color: Colors.black)
                    ),
                    child: SingleChildScrollView(
                      child: TextField(
                        controller: _alamatController,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: alamat.isEmpty ? "Alamat" : alamat,
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 160,
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
                    height: 90,
                    width: 320,
                    padding: EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                      color: ThemeColor.darkColor, // Warna background kontainer
                      borderRadius:
                          BorderRadius.circular(10), // BorderRadius untuk sudut
                      // border: Border.all(color: Colors.black)
                    ),
                    child: SingleChildScrollView(
                      child: TextField(
                        controller: _textController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: textData.isEmpty
                              ? "Isi deskripsi laporan"
                              : textData,
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 125,
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
                    height: 80,
                    width: 320,
                    padding: EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                      color: ThemeColor.darkColor, // Warna background kontainer
                      borderRadius:
                          BorderRadius.circular(10), // BorderRadius untuk sudut
                      // border: Border.all(color: Colors.black)
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          padding: EdgeInsets.all(5),
                          // decoration: BoxDecoration(
                          //   border: Border.all(color: Colors.black),
                          // ),
                          child: _fileName != null
                              ? Image.asset("images/$_fileName")
                              : _imageUrl != null
                                  ? Image.network(_imageUrl!)
                                  : Icon(Icons.camera_alt, color: Colors.grey),
                        ),
                        Spacer(),
                        Container(
                          child: 
                          !isAdmin
                            ? ElevatedButton(
                                onPressed:() {},
                                child: Text(
                                  "Upload Gambar",
                                  style: ThemeTextStyle().textWhite,
                                ),
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(160, 20),
                                  backgroundColor: ThemeColor.dark,
                              ),
                            )
                            : ElevatedButton(
                                onPressed: _pickImageFromGallery,
                                child: Text(
                                  "Upload Gambar",
                                  style: ThemeTextStyle().textWhite,
                                ),
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(160, 20),
                                  backgroundColor: ThemeColor.dark,
                                ),
                              )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (isAdmin)
              Container(
                height: 35,
                width: 360,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: ThemeColor.backgroundApp,
                  borderRadius: BorderRadius.circular(10),
                  // border: Border.all(color: Colors.black)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (dataPengaduan.isEmpty)
                      InkWell(
                        onTap: () {
                          setState(() {
                            addPengaduan(userId, _alamatController.text,
                                _textController.text, _fileName);
                          });
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
                    Container(
                      decoration: BoxDecoration(
                        color: ThemeColor.greyColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          if (dataPengaduan.isNotEmpty)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  deletePengaduan();
                                });
                              },
                              child: Icon(
                                Icons.delete,
                                color: ThemeColor.whiteColor,
                              ),
                            ),
                          SizedBox(width: 10),
                          if (dataPengaduan.isNotEmpty)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  updatePengaduan(_alamatController.text,
                                      _textController.text, _fileName);
                                });
                              },
                              child: Icon(
                                Icons.edit,
                                color: ThemeColor.whiteColor,
                              ),
                            ),
                          SizedBox(width: 10),
                        ],
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}


// android:requestLegacyExternalStorage="true"