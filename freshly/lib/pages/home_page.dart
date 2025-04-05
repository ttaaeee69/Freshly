import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.account_circle_rounded,
              size: 60, color: Colors.black),
        ),
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi Varich Maleevan!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: HexColor("#2C4340"),
              ),
            ),
            const Text("Welcome back"),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.circle_notifications_rounded, size: 40),
          ),
        ],
      ),
    );
  }
}

class FoodItem extends StatelessWidget {
  final IconData icon;
  final String name;

  const FoodItem({required this.icon, required this.name});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(icon, color: Colors.black),
      ),
      title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('since dd/mm/yyyy'),
      trailing: Text('x days ago', style: TextStyle(color: Colors.purple)),
    );
  }
}
