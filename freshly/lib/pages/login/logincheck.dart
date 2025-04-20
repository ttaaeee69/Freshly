import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../page_navigator.dart'; // Import for navigating between pages
import 'login.dart'; // Import for the login page

class LoginCheck extends StatelessWidget {
  const LoginCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Listen to authentication state changes
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check if the connection to the stream is active
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // If the user is authenticated, navigate to the main app
            User? user = snapshot.data;
            return PageNavigator(user: user!);
          } else {
            // If no user is authenticated, show the login page
            return FirstLoginPage();
          }
        }
        // Show a loading indicator while waiting for the authentication state
        return CircularProgressIndicator();
      },
    );
  }
}
