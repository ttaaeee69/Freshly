import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 40,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search for menu by ingredient . . .',
                labelStyle: TextStyle(
                  color: HexColor("#8F9E85"),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                isDense: true,
                filled: true,
                fillColor: HexColor("#DEDEDE"),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              "Recommend from you to have :",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
