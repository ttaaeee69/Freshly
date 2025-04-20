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
  File? _selectedImage; // Selected image file
  User user = FirebaseAuth.instance.currentUser!; // Current user
  bool isEdited = false; // Tracks if the profile is being edited
  String? _profileImageUrl; // URL of the profile image
  String? _username; // Username of the user

  @override
  void initState() {
    super.initState();
    _fetchProfileImage(); // Fetch profile image and username on initialization
  }

  // Fetches the profile image and username from Firestore
  Future<void> _fetchProfileImage() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('user') // Firestore collection name
          .where("uid", isEqualTo: user.uid) // Filter by user ID
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        String? imageUrl = userDoc['profileImage'];
        String? username = userDoc['username']; // Username field in Firestore

        setState(() {
          if (imageUrl != null && imageUrl.isNotEmpty) {
            _profileImageUrl = imageUrl; // Set profile image URL
          }

          if (username != null && username.isNotEmpty) {
            _username = username; // Set username
          }
        });
      }
    } catch (error) {
      print("Error fetching profile image and username: $error");
    }
  }

  // Logs out the user
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  // Picks an image from the gallery
  Future<void> _pickImageFromGallery() async {
    final picker = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picker != null) {
      setState(() {
        _selectedImage = File(picker.path); // Set the selected image
        isEdited = true; // Mark profile as edited
      });
    }
  }

  // Uploads the selected image to Firebase Storage
  Future<String> _uploadImageToFirebase() async {
    if (_selectedImage == null) {
      throw Exception("No image selected for upload.");
    }

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final imageRef = storageRef.child('profile_images/$fileName.jpg');

      await imageRef.putFile(_selectedImage!); // Upload the image

      return await imageRef.getDownloadURL(); // Get the download URL
    } catch (e) {
      throw Exception("Failed to upload image: $e");
    }
  }

  // Updates the profile image in Firestore
  Future<void> _updateProfileImage() async {
    if (_selectedImage != null) {
      try {
        String imageUrl = await _uploadImageToFirebase(); // Upload image
        final getUserData = await FirebaseFirestore.instance
            .collection('user')
            .where("uid", isEqualTo: user.uid)
            .get();

        if (getUserData.docs.isNotEmpty) {
          final userDoc = getUserData.docs.first;
          await FirebaseFirestore.instance
              .collection('user')
              .doc(userDoc.id)
              .update({'profileImage': imageUrl}); // Update Firestore

          setState(() {
            _profileImageUrl = imageUrl; // Update local state
          });
        }
      } catch (e) {
        print("Error updating profile image: $e");
      }
    }
    setState(() => isEdited = false); // Reset edit state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            spacing: 20, // Spacing between elements
            children: [
              // Profile container
              Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: HexColor("#E4C1C1"), // Background color
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
                      radius: 50, // Avatar size
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!) // Display selected image
                          : (_profileImageUrl != null
                              ? NetworkImage(_profileImageUrl!) // Display profile image
                              : const NetworkImage(
                                  "https://www.w3schools.com/howto/img_avatar.png")), // Default avatar
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _pickImageFromGallery, // Pick image from gallery
                      child: const Text(
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
                          backgroundColor: HexColor("#ADB2D4"), // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: _updateProfileImage, // Save profile image
                        child: const Text(
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
              // Details container
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: HexColor("#97A78D"), // Background color
                  borderRadius: BorderRadius.circular(20.0),
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10, // Spacing between elements
                  children: [
                    const Text(
                      "Details",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Username field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Username :",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 40,
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 15.0),
                          decoration: BoxDecoration(
                            color: HexColor("#EEF1DA"), // Field background color
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _username ?? "", // Display username
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_rounded),
                                iconSize: 18.0,
                                color: HexColor('#2C4340'),
                                onPressed: () async {
                                  final newUsername = await showDialog<String>(
                                    context: context,
                                    builder: (context) => EditUsernameDialog(
                                      currentUsername: _username ?? '',
                                    ),
                                  );

                                  if (newUsername != null) {
                                    setState(() {
                                      _username = newUsername; // Update username
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Email field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Email :",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 40,
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 15.0),
                          decoration: BoxDecoration(
                            color: HexColor("#EEF1DA"), // Field background color
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            user.email ?? "", // Display email
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Logout button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor("#ADB2D4"), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: _logout, // Log out the user
                  child: const Text(
                    "Log out",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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

class EditUsernameDialog extends StatefulWidget {
  final String currentUsername;

  const EditUsernameDialog({super.key, required this.currentUsername});

  @override
  State<EditUsernameDialog> createState() => _EditUsernameDialogState();
}

class _EditUsernameDialogState extends State<EditUsernameDialog> {
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.currentUsername);
  }

  Future<void> _updateUsername() async {
    if (_usernameController.text.isNotEmpty) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('user')
            .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get();

        if (userDoc.docs.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('user')
              .doc(userDoc.docs.first.id)
              .update({'username': _usernameController.text});

          // Update local state
          if (mounted) {
            Navigator.of(context).pop(_usernameController.text);
          }
        }
      } catch (e) {
        print("Error updating username: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Username',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
      content: TextField(
        controller: _usernameController,
        decoration: const InputDecoration(
          labelText: 'Username',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
              )),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: HexColor("#ADB2D4"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          onPressed: _updateUsername,
          child: Text('Save',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: HexColor('#2C4340'),
              )),
        ),
      ],
    );
  }
}
