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
  List<CameraDescription> cameras = [];
  CameraController? cameraController;

  @override
  void initState() {
    super.initState();
    _setupCameraController();
  }

  Future<void> _setupCameraController() async {
    List<CameraDescription> _cameras = await availableCameras();

    if (_cameras.isNotEmpty) {
      setState(() {
        cameras = _cameras;
        cameraController = CameraController(
          _cameras.first,
          ResolutionPreset.high,
        );
      });
      cameraController?.initialize().then((_) => setState(() {}));
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#ADB2D4"),
      appBar: AppBar(
        toolbarHeight: 100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: HexColor("#2C4340")),
          onPressed: () => Navigator.pop(context),
          padding: const EdgeInsets.only(left: 20),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3, // Allocate 3 parts of the space for the camera preview
            child: Container(
              alignment: Alignment.center,
              child: cameraController == null ||
                      cameraController?.value.isInitialized == false
                  ? const Center(child: CupertinoActivityIndicator())
                  : AspectRatio(
                      aspectRatio: 3 / 4, // Set the aspect ratio to 4:3
                      child: CameraPreview(cameraController!),
                    ),
            ),
          ),
          Expanded(
            flex: 1, // Allocate 1 part of the space for the bottom container
            child: Container(
              color: HexColor("#ADB2D4"),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (cameraController != null &&
                          cameraController!.value.isInitialized) {
                        try {
                          XFile image = await cameraController!.takePicture();
                          Navigator.pop(context, File(image.path));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      }
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 4,
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
