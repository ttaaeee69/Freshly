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

class AddFoodPage extends StatefulWidget {
  final String foodType; // "ingredient" or "cooked"

  const AddFoodPage({super.key, required this.foodType});

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  DateTime? startDate; // Start date of the food
  DateTime? expirationDate; // Expiration date of the food (optional)
  User user = FirebaseAuth.instance.currentUser!; // Current user
  File? selectedImage; // To store the selected image file

  final TextEditingController _nameController =
      TextEditingController(); // Controller for the food name

  // Uploads the selected image to Firebase Storage
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

  // Adds the food to Firestore
  Future<void> _addFood(context) async {
    final name = _nameController.text.trim();

    // Validate required fields
    if (name.isEmpty || startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
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

    // Create a food object
    final food = Food(
      uid: user.uid,
      name: name,
      startDate: startDate.toString(),
      expDate: expirationDate?.toString(),
      type: widget.foodType, // Use the food type passed to the page
      imageUrl: imageUrl,
    );

    // Save the food to Firestore
    try {
      await FirebaseFirestore.instance.collection("food").add(food.toMap());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add ${widget.foodType}: $e')),
      );
      return;
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('${widget.foodType.capitalize()} added successfully')),
    );

    Navigator.pop(context); // Navigate back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100, // Set AppBar height
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios), // Back button icon
          color: HexColor("#2C4340"), // Icon color
          onPressed: () => Navigator.pop(context), // Navigate back
          padding: const EdgeInsets.only(left: 20), // Adjust padding
        ),
        centerTitle: false,
        title: Text(
          "Adding ${widget.foodType.capitalize()} to your fridge", // Page title
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
            spacing: 30, // Spacing between elements
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Food profile container
              Container(
                decoration: BoxDecoration(
                  color: HexColor("#E4C1C1"), // Background color
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    spacing: 20, // Spacing between elements
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Add ${widget.foodType.capitalize()}'s profile", // Section title
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 10, // Spacing between elements
                        children: [
                          // Display the selected image in a 1:1 ratio
                          if (selectedImage != null)
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color:
                                    Colors.grey.shade300, // Placeholder color
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: FileImage(
                                      selectedImage!), // Display selected image
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                color: HexColor(
                                    "#DEDEDE"), // Button background color
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt, // Camera icon
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
              // Food details container
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: HexColor("#97A78D"), // Background color
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10, // Spacing between elements
                  children: [
                    Text(
                      "Details", // Section title
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name field
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
                            fillColor:
                                HexColor("#EEF1DA"), // Field background color
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
                            color: HexColor("#2C4340"), // Text color
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Start date field
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
                              setState(() => startDate =
                                  selectedDate); // Update start date
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  HexColor("#EEF1DA"), // Field background color
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  startDate != null
                                      ? DateFormat("dd/MM/yyyy").format(
                                          startDate!) // Display selected date
                                      : "",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: HexColor("#2C4340"), // Text color
                                  ),
                                ),
                                Icon(Icons.calendar_month), // Calendar icon
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Expiration date field (optional)
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
                              setState(() => expirationDate =
                                  selectedDate); // Update expiration date
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  HexColor("#EEF1DA"), // Field background color
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  expirationDate != null
                                      ? DateFormat("dd/MM/yyyy").format(
                                          expirationDate!) // Display selected date
                                      : "",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: HexColor("#2C4340"), // Text color
                                  ),
                                ),
                                Icon(Icons.calendar_month), // Calendar icon
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Submit button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      HexColor("#ADB2D4"), // Button background color
                ),
                onPressed: () {
                  _addFood(context); // Add food to Firestore
                },
                child: Text(
                  "Done", // Button text
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: HexColor("#2C4340"), // Text color
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

// Extension to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
