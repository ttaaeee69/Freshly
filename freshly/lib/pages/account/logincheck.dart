import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../page_navigator.dart';
import 'login.dart';

class LoginCheck extends StatelessWidget {
  const LoginCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              User? user = snapshot.data;

              return PageNavigator(user: user!);
            } else {
              return FirstLoginPage();
            }
          }
          return CircularProgressIndicator();
        });
  }
}
