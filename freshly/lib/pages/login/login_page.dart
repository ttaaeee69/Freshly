import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hexcolor/hexcolor.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  bool _isObscure = true; // Controls password visibility

  // Controllers for email and password fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Handles user login
  Future<void> _login(context) async {
    final email = _emailController.text.trim().toLowerCase(); // Get email input
    final password = _passwordController.text; // Get password input

    try {
      // Attempt to sign in with Firebase Authentication
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login successful!"),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to the previous page
      Navigator.pop(context);
    } catch (e) {
      // Show error message if login fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login failed: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
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
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 150.0),
          child: Column(
            spacing: 30, // Spacing between elements
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Login form container
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
                      "Login",
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
                            keyboardType: TextInputType.emailAddress,
                            validator: MultiValidator(
                              [
                                RequiredValidator(
                                    errorText: "Please enter your Email"),
                                EmailValidator(
                                    errorText: "Email Format Incorrect!!!")
                              ],
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
                            obscureText: _isObscure, // Hide password text
                            validator: RequiredValidator(
                                    errorText: "Please enter your Password")
                                .call,
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
                                  setState(
                                    () {
                                      _isObscure =
                                          !_isObscure; // Toggle visibility
                                    },
                                  );
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Validate form and log in
                    _login(context);
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
    );
  }
}
