import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CameraUI extends StatefulWidget {
  const CameraUI({super.key});

  @override
  State<CameraUI> createState() => _CameraUIState();
}

class _CameraUIState extends State<CameraUI> {
  List<CameraDescription> cameras = []; // List of available cameras
  CameraController? cameraController; // Controller for the camera

  @override
  void initState() {
    super.initState();
    _setupCameraController(); // Initialize the camera controller
  }

  // Sets up the camera controller
  Future<void> _setupCameraController() async {
    List<CameraDescription> _cameras =
        await availableCameras(); // Get available cameras

    if (_cameras.isNotEmpty) {
      setState(() {
        cameras = _cameras; // Store the list of cameras
        cameraController = CameraController(
          _cameras.first, // Use the first available camera
          ResolutionPreset.high, // Set resolution to high
        );
      });
      cameraController
          ?.initialize()
          .then((_) => setState(() {})); // Initialize the controller
    }
  }

  @override
  void dispose() {
    cameraController?.dispose(); // Dispose of the camera controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#ADB2D4"), // Background color
      appBar: AppBar(
        toolbarHeight: 100, // Set AppBar height
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: HexColor("#2C4340")), // Back button
          onPressed: () => Navigator.pop(context), // Navigate back
          padding: const EdgeInsets.only(left: 20), // Adjust padding
        ),
      ),
      body: Column(
        children: [
          // Camera preview section
          Expanded(
            flex: 3, // Allocate 3 parts of the space for the camera preview
            child: Container(
              alignment: Alignment.center,
              child: cameraController == null ||
                      cameraController?.value.isInitialized == false
                  ? const Center(
                      child:
                          CupertinoActivityIndicator()) // Show loading indicator
                  : AspectRatio(
                      aspectRatio: 3 / 4, // Set the aspect ratio to 4:3
                      child: CameraPreview(
                          cameraController!), // Display camera preview
                    ),
            ),
          ),
          // Bottom container with capture button
          Expanded(
            flex: 1, // Allocate 1 part of the space for the bottom container
            child: Container(
              color: HexColor("#ADB2D4"), // Background color
              padding:
                  const EdgeInsets.symmetric(vertical: 20), // Vertical padding
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center the button
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (cameraController != null &&
                          cameraController!.value.isInitialized) {
                        try {
                          // Capture the image
                          XFile image = await cameraController!.takePicture();
                          Navigator.pop(context,
                              File(image.path)); // Return the captured image
                        } catch (e) {
                          // Show error message if capturing fails
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      }
                    },
                    child: Container(
                      width: 70, // Button width
                      height: 70, // Button height
                      decoration: BoxDecoration(
                        color: Colors.white, // Button color
                        shape: BoxShape.circle, // Circular shape
                        border: Border.all(
                          color: Colors.grey.shade300, // Border color
                          width: 4, // Border width
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
