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
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          spacing: 30,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: HexColor("#E4C1C1"),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    Text(
                      "Add food's profile",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 10,
                      children: [
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: HexColor("#DEDEDE"),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 30,
                            ),
                          ),
                          onPressed: () {},
                        ),
                        Text(
                          "or",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: HexColor("#DEDEDE"),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add_reaction_outlined,
                              size: 30,
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: HexColor("#97A78D"),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name :",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: HexColor("#EEF1DA"),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: HexColor("#2C4340"),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Since :",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: HexColor("#EEF1DA"),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: HexColor("#2C4340"),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Expiration Date :",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: HexColor("#EEF1DA"),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: HexColor("#2C4340"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: HexColor("#ADB2D4"),
              ),
              onPressed: () {},
              child: Text(
                "Done",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: HexColor("#2C4340"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
