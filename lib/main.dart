import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_app/screens/adduser.dart';
import 'package:student_app/screens/grid.dart';
import 'package:student_app/screens/home.dart';
import 'package:student_app/screens/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      routes: {
        '/': (context) => const Log(),
        '/home': (context) => Home(),
        '/adduser': (context) => Adduser(),
        '/grid': (context) => UserlistGrid(),
      },
    );
  }
}
