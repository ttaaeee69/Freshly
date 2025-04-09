import 'package:flutter/material.dart';
//ยังไม่เสร็จ
// void main() {
//   runApp(MaterialApp(home: AccountPage()));
// }

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FCE6), // pale yellow background
      body: Column(
        children: [
          // Top section
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFB9B8E3), // light purple
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFFF5F9D5),
                  child: Icon(Icons.person, color: Colors.black),
                ),
                Text(
                  'Your Account',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                CircleAvatar(
                  backgroundColor: Color(0xFFF5F9D5),
                  child: Icon(Icons.notifications, color: Colors.black),
                ),
              ],
            ),
          ),

          SizedBox(height: 40),

          // Middle card
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFFF4C7C3), // soft pink
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                CustomButton(text: "Sign-up"),
                SizedBox(height: 15),
                CustomButton(text: "Log-in"),
                SizedBox(height: 15),
                Divider(thickness: 2, color: Colors.black),
                SizedBox(height: 15),
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
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
        ],
      ),

       // Bottom nav bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFB9B8E3),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        currentIndex: 3, // Account selected
        items: [
          BottomNavigationBarItem(
            icon: Image.asset("assets/home_cake.png", height: 30),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/cookie.png", height: 30),
            label: "Fridge",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/sushi.png", height: 30),
            label: "Menu",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/bowl.png", height: 30),
            label: "Account",
          ),
        ],
      ),
    );
  }
}

// Reusable styled button
class CustomButton extends StatelessWidget {
  final String text;

  const CustomButton({required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFB9B8E3), // soft purple
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        minimumSize: Size(double.infinity, 50),
        elevation: 0,
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }
}
