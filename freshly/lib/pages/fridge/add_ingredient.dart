import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freshly/models/food.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'camera.dart';

class AddIngredientPage extends StatefulWidget {
  const AddIngredientPage({super.key});

  @override
  State<AddIngredientPage> createState() => _AddIngredientPageState();
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  DateTime? startDate;
  DateTime? expirationDate;
  User user = FirebaseAuth.instance.currentUser!;
  File? selectedImage; // To store the selected image file

  final TextEditingController _nameController = TextEditingController();

  Future<String> _uploadImageToFirebase(File image) async {
    try {
      // Generate a unique file name
      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload the image to Firebase Storage
      final ref = FirebaseStorage.instance.ref().child(fileName);
      await ref.putFile(image);

      // Get the download URL
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<void> _addIngredient(context) async {
    final name = _nameController.text.trim();

    if (name.isEmpty || startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    String? imageUrl;
    try {
      if (selectedImage != null) {
        // Upload the image to Firebase Storage and get the URL
        imageUrl = await _uploadImageToFirebase(selectedImage!);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      return;
    }

    final ingredient = Food(
      uid: user.uid,
      name: name,
      startDate: startDate.toString(),
      expDate: expirationDate?.toString(),
      type: "ingredient",
      imageUrl: imageUrl,
    );

    // Save the ingredient to Firestore
    try {
      await FirebaseFirestore.instance
          .collection("food")
          .add(ingredient.toMap());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add ingredient: $e')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ingredient added successfully')),
    );

    Navigator.pop(context);
  }

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
      body: SingleChildScrollView(
        child: Padding(
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
                    spacing: 20,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Add food's profile",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 10,
                        children: [
                          // Display the selected image in a 1:1 ratio
                          if (selectedImage != null)
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: FileImage(selectedImage!),
                                  fit: BoxFit.cover,
                                ),
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
                                Icons.camera_alt,
                                size: 30,
                              ),
                            ),
                            onPressed: () async {
                              // Navigate to the CameraUI page and wait for the result
                              final File? image = await Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => const CameraUI(),
                                ),
                              );
                              if (image != null) {
                                setState(() {
                                  selectedImage =
                                      image; // Update the selected image
                                });
                              }
                            },
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
                          controller: _nameController,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: HexColor("#EEF1DA"),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 16,
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
                        GestureDetector(
                          onTap: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              setState(() => startDate = selectedDate);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                              color: HexColor("#EEF1DA"),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  startDate != null
                                      ? DateFormat("dd/MM/yyyy")
                                          .format(startDate!)
                                      : "",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: HexColor("#2C4340"),
                                  ),
                                ),
                                Icon(Icons.calendar_month),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Expiration Date : (Optional)",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              setState(() => expirationDate = selectedDate);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                              color: HexColor("#EEF1DA"),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  expirationDate != null
                                      ? DateFormat("dd/MM/yyyy")
                                          .format(expirationDate!)
                                      : "",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: HexColor("#2C4340"),
                                  ),
                                ),
                                Icon(Icons.calendar_month),
                              ],
                            ),
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
                onPressed: () {
                  _addIngredient(context);
                },
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
      ),
    );
  }
}
