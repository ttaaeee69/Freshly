import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
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
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF2C4340)),
          bodyMedium: TextStyle(color: Color(0xFF2C4340)),
          bodySmall: TextStyle(color: Color(0xFF2C4340)),
        ),
      ),
      home: const HomePage(),
    );
  }
}
