import 'package:flutter/material.dart';
import 'package:pengaduan_kebakaran_app/API/api_connection.dart';
import 'package:pengaduan_kebakaran_app/theme/theme_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List dataPengaduan = [];
  int? userId;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    getPengaduan();
  }

  Future<void> getPengaduan() async {
    String uri = API.readPengaduan;
    try {
      var response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        setState(() {
          dataPengaduan = jsonDecode(response.body);
        });
      } else {
        print('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getInt('id_pengguna') != null;

    if (isLoggedIn) {
      setState(() {
        userId = prefs.getInt('id_pengguna') ?? 0;
      });
    } else {
      Navigator.pushReplacementNamed(context, 'Login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.backgroundApp,
      appBar: AppBar(
        backgroundColor: ThemeColor.dark,
        title: Center(
          child: Image.asset(
            "images/logo_aplikasi.png",
            height: 200,
            width: 200,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: ThemeColor.whiteColor),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('id_pengguna');
              Navigator.pushReplacementNamed(context, 'Login');
            },
          ),
        ],
      ),
      body: ListView(children: [
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigasi ke halaman Tentang
                    Navigator.pushNamed(context, 'TentangAplikasi',
                        arguments: userId);
                  },
                  child: Icon(
                    Icons.article,
                    color: ThemeColor.whiteColor,
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColor.dark),
                ),
                Text("Tentang")
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigasi ke halaman Pengaduan
                    Navigator.pushNamed(context, 'Pengaduan',
                        arguments: userId);
                  },
                  child: Icon(
                    Icons.info,
                    color: ThemeColor.whiteColor,
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColor.dark),
                ),
                Text("Pengaduan")
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigasi ke halaman Contact
                    Navigator.pushNamed(context, 'Contact', arguments: userId);
                  },
                  child: Icon(
                    Icons.call,
                    color: ThemeColor.whiteColor,
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColor.dark),
                ),
                Text("Contact")
              ],
            ),
          ],
        ),
        SizedBox(
          height: 40,
        ),
        Container(
          height: 420,
          margin: EdgeInsets.only(left: 40, right: 40),
          decoration: BoxDecoration(
            color: ThemeColor.darkColor, // Warna background kontainer
            borderRadius: BorderRadius.circular(10), // BorderRadius untuk sudut
            // border: Border.all(color: Colors.black)
          ),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              dataPengaduan.isEmpty
                  ? Text("Tidak ada kebakaran")
                  : Text("${dataPengaduan[0]['alamat']}"),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 260,
                width: 260,
                margin: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: ThemeColor.blackColor, // Warna background kontainer
                  borderRadius:
                      BorderRadius.circular(10), // BorderRadius untuk sudut
                  // border: Border.all(color: Colors.black)
                ),
                child: 
                dataPengaduan.isEmpty
                  ? Image.asset(
                      "images/camera.png"
                    )
                  : Image.asset(
                      "images/${dataPengaduan[0]['image_path']}"
                    ),
              ),
              SizedBox(
                height: 10,
              ),
              dataPengaduan.isEmpty
                  ? Text("Tidak ada deskripsi kebakaran")
                  : Text("${dataPengaduan[0]['deskripsi']}"),
            ],
          ),
        )
      ]),
    );
  }
}
