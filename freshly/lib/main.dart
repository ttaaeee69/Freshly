import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const Freshly());
}

class Freshly extends StatelessWidget {
  const Freshly({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Freshly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: HexColor("#DEDEDE"),
        appBarTheme: AppBarTheme(
          backgroundColor: HexColor('#ADB2D4'),
          titleTextStyle: TextStyle(
            color: HexColor("#2C4340"),
          ),
        ),
        textTheme: GoogleFonts.outfitTextTheme(),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
