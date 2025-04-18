import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'register_page.dart';
import 'login_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: HexColor("#E4C1C1"), // soft pink
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  spacing: 15,
                  children: [
                    CustomButton(text: "Sign-up"),
                    CustomButton(text: "Log-in"),
                    Divider(
                      thickness: 2,
                      color: HexColor("#2C4340"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          FirebaseAuth.instance.signInAnonymously();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Login failed: ${e.toString()}"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor("#EEF1DA"),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "Continue as guest",
                          style: TextStyle(
                            color: HexColor("#2C4340"),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: -15, // Adjust the vertical position
                right: 15, // Adjust the horizontal position
                child: Image.asset(
                  "assets/img/cake.PNG",
                  width: 55,
                  height: 55,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Reusable styled button
class CustomButton extends StatelessWidget {
  final String text;

  const CustomButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (text == "Sign-up") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => RegisterPage()));
        } else if (text == "Log-in") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: HexColor("#ADB2D4"), // soft purple
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 0,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: HexColor("#2C4340"),
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
