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
  String? _profileImageUrl;
  String? _username;

  @override
  void initState() {
    super.initState();
    _fetchProfileImage();
  }

  Future<void> _fetchProfileImage() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection(
              'user') // Ensure this matches your Firestore collection name
          .where("uid", isEqualTo: user.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        String? imageUrl = userDoc['profileImage'];
        String? username = userDoc[
            'username']; // Assuming 'username' is the field name in Firestore

        setState(() {
          if (imageUrl != null && imageUrl.isNotEmpty) {
            _profileImageUrl = imageUrl;
          } else {
            print("No profile image found for user.");
          }

          if (username != null && username.isNotEmpty) {
            _username =
                username; // Add a new state variable `_username` to store the username
          } else {
            print("No username found for user.");
          }
        });
      } else {
        print("No user document found for UID: ${user.uid}");
      }
    } catch (error) {
      print("Error fetching profile image and username: $error");
    }
  }

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
    if (_selectedImage == null) {
      throw Exception("No image selected for upload.");
    }
    print(_selectedImage!.path);

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final imageRef = storageRef.child('profile_images/$fileName.jpg');

      print("Uploading image: ${_selectedImage!.path}");
      await imageRef.putFile(_selectedImage!);

      final downloadUrl = await imageRef.getDownloadURL();
      print("Image uploaded successfully: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      throw Exception("Failed to upload image: $e");
    }
  }

  Future<void> _updateProfileImage() async {
    if (_selectedImage != null) {
      try {
        String imageUrl = await _uploadImageToFirebase();
        final getUserData = await FirebaseFirestore.instance
            .collection('user')
            .where("uid", isEqualTo: user.uid)
            .get();

        if (getUserData.docs.isNotEmpty) {
          final userDoc = getUserData.docs.first;
          print("Updating Firestore document: ${userDoc.id}");
          await FirebaseFirestore.instance
              .collection('user')
              .doc(userDoc.id)
              .update({'profileImage': imageUrl});
          print("Firestore updated successfully with imageUrl: $imageUrl");

          // Update the local state
          setState(() {
            _profileImageUrl = imageUrl;
          });
        } else {
          print("No user document found for UID: ${user.uid}");
        }
      } catch (e) {
        print("Error updating profile image: $e");
      }
    }
    setState(() => isEdited = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
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
                          : (_profileImageUrl != null
                              ? NetworkImage(_profileImageUrl!)
                              : const NetworkImage(
                                  "https://www.w3schools.com/howto/img_avatar.png")),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
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
                            color: HexColor("#EEF1DA"),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _username ?? "",
                                style: TextStyle(
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
                                      _username = newUsername;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Email Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
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
                            color: HexColor("#EEF1DA"),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            user.email ?? "",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Passowrd Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Password :",
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
                            color: HexColor("#EEF1DA"),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            "********",
                            style: TextStyle(
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
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor("#ADB2D4"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: _logout,
                  child: Text(
                    "Log out",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: HexColor('#2C4340')),
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
