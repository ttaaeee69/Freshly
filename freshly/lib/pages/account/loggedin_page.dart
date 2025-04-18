import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class LoggedInPage extends StatelessWidget {
  const LoggedInPage({super.key, User? user});

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          spacing: 20,
          children: [
            Container(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: HexColor("#E4C1C1"),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                children: [
                  const Text(
                    "Your profile",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        "https://www.w3schools.com/howto/img_avatar.png"),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Edit",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: HexColor("#97A78D"),
                borderRadius: BorderRadius.circular(20.0),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    "Details",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Username Field
                  Column(
                    children: [
                      Text(
                        "Username :",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(""),
                    ],
                  ),
                ],
              ),
            ),
            Center(
                child:
                    ElevatedButton(onPressed: _logout, child: Text("Log out"))),
          ],
        ),
      ),
    );
  }
}
