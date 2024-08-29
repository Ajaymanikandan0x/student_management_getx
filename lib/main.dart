import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_app/pages/adduser.dart';
import 'package:student_app/pages/grid.dart';
import 'package:student_app/pages/home.dart';
import 'package:student_app/pages/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      routes: {
        '/': (context) => const Log(),
        '/home': (context) => Home(),
        '/adduser': (context) => Adduser(),
        '/grid': (context) => UserlistGrid(),
      },
    ),
  );
}
