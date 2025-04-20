import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:form_field_validator/form_field_validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  bool _isObscure = true; // Controls password visibility

  // Controllers for form fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  // Handles user registration
  Future<void> _createUser(context) async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    try {
      // Create user with Firebase Authentication
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Add user details to Firestore
      FirebaseFirestore.instance.collection("user").add(
        {
          "uid": user.user!.uid,
          "email": email,
          "username": username,
          "profileImage": "",
        },
      ).then(
        (value) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Registration successful!"),
              backgroundColor: Colors.green,
            ),
          );
        },
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registration failed: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
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
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 150.0),
            child: Column(
              spacing: 30, // Spacing between elements
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Registration form container
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: HexColor("#97A78D"), // Background color
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 10, // Spacing between elements
                    children: [
                      // Title
                      Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Form
                      Form(
                        key: _formKey, // Assign form key
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Username field
                            Text(
                              "Username :",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _usernameController,
                              validator: RequiredValidator(
                                errorText: "Please enter your Username",
                              ).call,
                              decoration: InputDecoration(
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
                            const SizedBox(height: 10),

                            // Email field
                            Text(
                              "Email :",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _emailController,
                              validator: MultiValidator(
                                [
                                  RequiredValidator(
                                      errorText: "Please enter your Email"),
                                  EmailValidator(
                                      errorText: "Email Format Incorrect!!!")
                                ],
                              ).call,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
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
                            const SizedBox(height: 10),

                            // Password field
                            Text(
                              "Password :",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _passwordController,
                              validator: MultiValidator(
                                [
                                  RequiredValidator(
                                      errorText: "Please enter your Password"),
                                  MinLengthValidator(6,
                                      errorText:
                                          "Password must be at least 6 characters long"),
                                ],
                              ).call,
                              obscureText: _isObscure, // Hide password text
                              decoration: InputDecoration(
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
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: HexColor("#2C4340"),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure =
                                          !_isObscure; // Toggle visibility
                                    });
                                  },
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                color: HexColor("#2C4340"),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Submit button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor("#ADB2D4"), // Button color
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Validate form and create user
                      await _createUser(context);
                      Navigator.pop(context); // Navigate back on success
                    } else {
                      // Show error message if validation fails
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please fill in all fields correctly."),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Submit",
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
      ),
    );
  }
}
