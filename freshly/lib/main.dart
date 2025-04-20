// Importing necessary packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Importing Firebase options and login check page
import 'firebase_options.dart';
import 'pages/login/logincheck.dart';

Future<void> main() async {
  // Ensures Flutter bindings are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the main application
  runApp(const Freshly());
}

// Main application widget
class Freshly extends StatelessWidget {
  const Freshly({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Freshly', // Application title
      debugShowCheckedModeBanner: false, // Disable debug banner
      theme: ThemeData(
        // Define text theme using Google Fonts
        textTheme: GoogleFonts.outfitTextTheme().apply(
          bodyColor: HexColor("#2C4340"), // Body text color
          displayColor: HexColor("#2C4340"), // Display text color
        ),
        primarySwatch: Colors.purple, // Primary color swatch
        scaffoldBackgroundColor: HexColor("#EEF1DA"), // Background color
        appBarTheme: AppBarTheme(
          backgroundColor: HexColor('#ADB2D4'), // AppBar background color
          titleTextStyle: GoogleFonts.outfit(
            color: HexColor("#2C4340"), // AppBar title text color
          ),
        ),
      ),
      home: const LoginCheck(), // Initial page of the app
    );
  }
}
