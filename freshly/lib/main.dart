import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'pages/login/logincheck.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        textTheme: GoogleFonts.outfitTextTheme().apply(
          bodyColor: HexColor("#2C4340"),
          displayColor: HexColor("#2C4340"),
        ),
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: HexColor("#EEF1DA"),
        appBarTheme: AppBarTheme(
          backgroundColor: HexColor('#ADB2D4'),
          titleTextStyle: GoogleFonts.outfit(
            color: HexColor("#2C4340"),
          ),
        ),
      ),
      home: const LoginCheck(),
    );
  }
}
