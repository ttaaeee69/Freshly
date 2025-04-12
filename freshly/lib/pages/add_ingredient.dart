import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AddIngredientPage extends StatelessWidget {
  const AddIngredientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: HexColor("#2C4340"),
          onPressed: () => Navigator.pop(context),
          padding: const EdgeInsets.only(left: 20),
        ),
        centerTitle: false,
        title: Text(
          "Adding food into your fridge",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.circle_notifications_rounded,
              size: 40,
              color: Colors.black,
            ),
            onPressed: () {},
            padding: const EdgeInsets.only(right: 20),
          ),
        ],
      ),
    );
  }
}
