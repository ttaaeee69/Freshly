import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'account_page.dart';
import 'loggedin_page.dart';

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

              return LoggedInPage(user: user!);
            } else {
              return AccountPage();
            }
          }
          return CircularProgressIndicator();
        });
  }
}
