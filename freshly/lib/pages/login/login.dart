import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../models/profile.dart';
import 'register_page.dart'; // Import for the registration page
import 'login_page.dart'; // Import for the login page
import 'package:cloud_firestore/cloud_firestore.dart';

class FirstLoginPage extends StatelessWidget {
  const FirstLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center content vertically
        children: [
          Stack(
            children: [
              // Main container for buttons and content
              Container(
                margin:
                    EdgeInsets.symmetric(horizontal: 40), // Horizontal margin
                padding: EdgeInsets.all(30), // Padding inside the container
                decoration: BoxDecoration(
                  color: HexColor("#E4C1C1"), // Background color (soft pink)
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
                child: Column(
                  spacing: 15, // Spacing between elements
                  children: [
                    // Sign-up button
                    CustomButton(text: "Sign-up"),
                    // Log-in button
                    CustomButton(text: "Log-in"),
                    // Divider between buttons and guest login
                    Divider(
                      thickness: 2, // Divider thickness
                      color: HexColor("#2C4340"), // Divider color
                    ),
                    // Guest login button
                    SizedBox(
                      width: double.infinity, // Full width button
                      child: ElevatedButton(
                        onPressed: () async {
                          // Removed unused label 'width'
                          try {
                            // Sign in anonymously
                            await FirebaseAuth.instance.signInAnonymously();

                            // Send anonymous profile data
                            await sendAnonymousProfile();
                          } catch (e) {
                            // Show error message if login or data sending fails
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Failed to sign in anonymously: ${e.toString()}"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HexColor("#EEF1DA"), // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30), // Rounded corners
                          ),
                        ),
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
              // Positioned image decoration
              Positioned(
                top: -15, // Adjust the vertical position
                right: 15, // Adjust the horizontal position
                child: Image.asset(
                  "assets/img/cake.PNG", // Image path
                  width: 55, // Image width
                  height: 55, // Image height
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
  final String text; // Button text

  const CustomButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the appropriate page based on the button text
        if (text == "Sign-up") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => RegisterPage()));
        } else if (text == "Log-in") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: HexColor("#ADB2D4"), // Button color (soft purple)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded corners
        ),
        elevation: 0, // Remove button shadow
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 8.0), // Padding inside the button
        child: Center(
          child: Text(
            text, // Display button text
            style: TextStyle(
              color: HexColor("#2C4340"), // Text color
              fontSize: 16, // Font size
              fontWeight: FontWeight.bold, // Bold text
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> sendAnonymousProfile() async {
  try {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;

    // Ensure the user is signed in anonymously
    if (user != null && user.isAnonymous) {
      // Create an anonymous profile
      final anonymousProfile = Profile(
        uid: user.uid,
        username: "Anonymous", // Default anonymous username
        profileImage: "", // No profile image for anonymous users
      );

      // Save the profile to Firestore
      await FirebaseFirestore.instance
          .collection('user') // Firestore collection name
          .doc(user.uid) // Use the user's UID as the document ID
          .set(anonymousProfile.toMap());

      print("Anonymous profile sent successfully.");
    } else {
      print("User is not signed in anonymously.");
    }
  } catch (e) {
    print("Failed to send anonymous profile: $e");
  }
}
