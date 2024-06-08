import 'package:flutter/material.dart';
import 'package:pengaduan_kebakaran_app/authentication/login.dart';
import 'package:pengaduan_kebakaran_app/authentication/sign_in.dart';
import 'package:pengaduan_kebakaran_app/pages/add_contact.dart';
import 'package:pengaduan_kebakaran_app/pages/contact.dart';
import 'package:pengaduan_kebakaran_app/pages/edit_contact.dart';
import 'package:pengaduan_kebakaran_app/pages/home.dart';
import 'package:pengaduan_kebakaran_app/pages/pengaduan.dart';
import 'package:pengaduan_kebakaran_app/pages/tentang_aplikasi.dart';



// void main() => runApp(MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        "/"                   : (context) => Home(),
        "Login"               : (context) => Login(),
        "SignIn"              : (context) => SignIn(),
        "TentangAplikasi"     : (context) => TentangAplikasi(),
        "Pengaduan"           : (context) => Pengaduan(),
        "Contact"             : (context) => Contact(),

        "AddContact"          : (context) => AddContact(),
        "EditContact"         : (context) => EditContact(),
       
      },
    );
  }
}
