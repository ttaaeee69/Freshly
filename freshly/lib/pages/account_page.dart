import 'package:flutter/material.dart';

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
                  color: Color(0xFFF4C7C3), // soft pink
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  spacing: 15,
                  children: [
                    CustomButton(text: "Sign-up"),
                    CustomButton(text: "Log-in"),
                    Divider(thickness: 2, color: Colors.black),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF9FCE6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                          child: Text(
                            "Continue as guest",
                            style: TextStyle(color: Colors.black, fontSize: 16),
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
                  width: 60,
                  height: 60,
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
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFB9B8E3), // soft purple
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
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
