import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, User? user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _selectedImage;
  User user = FirebaseAuth.instance.currentUser!;
  bool isEdited = false;

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> _pickImageFromGallery() async {
    final picker = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picker != null) {
      setState(() {
        _selectedImage = File(picker.path);
        isEdited = true;
      });
    }
  }

  Future<String> _uploadImageToFirebase() async {
    if (_selectedImage == null) return "";

    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child('profile_images/${_selectedImage!.path}');
    await imageRef.putFile(_selectedImage!);
    return await imageRef.getDownloadURL();
  }

  Future<void> _updateProfileImage() async {
    if (_selectedImage != null) {
      String imageUrl = await _uploadImageToFirebase();
      final getUserData = await FirebaseFirestore.instance
          .collection('users')
          .where("uid", isEqualTo: user.uid)
          .get();
      if (getUserData.docs.isNotEmpty) {
        final userDoc = getUserData.docs.first;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id)
            .update({'profileImage': imageUrl});
      }
    }
    setState(() => isEdited = false);
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
              padding: const EdgeInsets.all(10),
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
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : const NetworkImage(
                            "https://www.w3schools.com/howto/img_avatar.png"),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: _pickImageFromGallery,
                    child: Text(
                      "Edit",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (isEdited)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor("#ADB2D4"),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: _updateProfileImage,
                      child: Text(
                        "Save",
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
