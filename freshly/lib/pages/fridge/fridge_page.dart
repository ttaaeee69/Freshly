import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'add_food.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../models/food.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'camera.dart';

class FridgePage extends StatefulWidget {
  const FridgePage({super.key});

  @override
  State<FridgePage> createState() => _FridgePageState();
}

class _FridgePageState extends State<FridgePage> {
  List<Food> _ingredients = [];
  List<Food> _cooked = [];
  User user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    _refreshFood();
  }

  String expCalculate(Timestamp startDate, Timestamp expDate) {
    DateTime start = startDate.toDate();
    DateTime now = DateTime.now();
    DateTime exp = expDate.toDate();
    bool isExpired = now.isAfter(exp);

    if (isExpired) {
      return "expired";
    } else {
      int daysLeft = exp.difference(start).inDays;
      return "$daysLeft days left";
    }
  }

  Future<void> _refreshFood() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("food")
        .where("uid", isEqualTo: user.uid)
        .orderBy("startDate", descending: true)
        .get();

    List<Food> loadedIngredients = [];
    List<Food> loadedCooked = [];

    late String? formatExpDate;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      Timestamp startDate = data["startDate"];
      DateTime star = startDate.toDate();
      String formatStartDate = DateFormat('dd/MM/yyyy').format(star);
      if (data["expDate"] == null) {
        formatExpDate = null;
      } else {
        Timestamp expDate = data["expDate"];
        DateTime exp = expDate.toDate();
        formatExpDate = DateFormat('dd/MM/yyyy').format(exp);
      }

      if (data["type"] == "ingredient") {
        loadedIngredients.add(
          Food(
            uid: user.uid,
            fid: doc.id,
            name: data["name"],
            startDate: formatStartDate,
            expDate: formatExpDate,
            isExpired: data["expDate"] != null
                ? expCalculate(
                    startDate,
                    data["expDate"],
                  )
                : "",
            type: data["type"],
            imageUrl: data["imageUrl"],
          ),
        );
      } else if (data["type"] == "cooked") {
        loadedCooked.add(Food(
          uid: user.uid,
          fid: doc.id,
          name: data["name"],
          startDate: formatStartDate,
          expDate: formatExpDate,
          isExpired: data["expDate"] != null
              ? expCalculate(
                  startDate,
                  data["expDate"],
                )
              : "",
          type: data["type"],
          imageUrl: data["imageUrl"],
        ));
      }
    }

    setState(() {
      _ingredients = loadedIngredients;
      _cooked = loadedCooked;
    });
  }

  Future<void> _deleteFood(String fid) async {
    await FirebaseFirestore.instance.collection("food").doc(fid).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              _buildIngredientSection(),
              const SizedBox(height: 30), // Add spacing between sections
              _buildCookedSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientSection() {
    return Container(
      decoration: BoxDecoration(
        color: HexColor("#E4C1C1"),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Ingredient",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _ingredients.isEmpty
                ? const Center(
                    child: Text("No ingredients available"),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _ingredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = _ingredients[index];
                      final isExpired = ingredient.isExpired;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Slidable(
                          key: Key(ingredient.fid!),
                          startActionPane: ActionPane(
                            motion: const BehindMotion(),
                            extentRatio: 0.2,
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  _deleteFood(ingredient.fid!)
                                      .then((_) => _refreshFood());
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("${ingredient.name} deleted"),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(20.0),
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: const BehindMotion(),
                            extentRatio: 0.2,
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => EditFoodDialog(
                                      food: ingredient,
                                    ),
                                  ).then((_) => _refreshFood());
                                },
                                borderRadius: BorderRadius.circular(20.0),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isExpired == "expired"
                                  ? HexColor("#D6805B")
                                  : HexColor("#EEF1DA"),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: ingredient.imageUrl != null
                                    ? NetworkImage(ingredient.imageUrl!)
                                    : null,
                                child: ingredient.imageUrl == null
                                    ? Text(
                                        ingredient.name.substring(0, 1),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      )
                                    : null,
                                backgroundColor: HexColor("#97A78D"),
                              ),
                              title: Text(
                                ingredient.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: HexColor("#2C4340"),
                                ),
                              ),
                              subtitle: Text(
                                "since ${ingredient.startDate}",
                              ),
                              trailing: Text(ingredient.isExpired!),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) =>
                        const AddFoodPage(foodType: "ingredient"),
                  ),
                ).then((_) => _refreshFood());
              },
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: HexColor("#D9D9D9"),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Icon(
                    Icons.add_circle_outline_rounded,
                    size: 28,
                    color: HexColor("#2C4340"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCookedSection() {
    return Container(
      decoration: BoxDecoration(
        color: HexColor("#ADB2D4"),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Cooked",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _cooked.isEmpty
                ? const Center(
                    child: Text("No cooked food available"),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _cooked.length,
                    itemBuilder: (context, index) {
                      final cooked = _cooked[index];
                      final isExpired = cooked.isExpired;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Slidable(
                          key: Key(cooked.fid!),
                          startActionPane: ActionPane(
                            motion: const BehindMotion(),
                            extentRatio: 0.2,
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  _deleteFood(cooked.fid!)
                                      .then((_) => _refreshFood());
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("${cooked.name} deleted"),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(20.0),
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: const BehindMotion(),
                            extentRatio: 0.2,
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => EditFoodDialog(
                                      food: cooked,
                                    ),
                                  ).then((_) => _refreshFood());
                                },
                                borderRadius: BorderRadius.circular(20.0),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isExpired == "expired"
                                  ? HexColor("#D6805B")
                                  : HexColor("#EEF1DA"),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: cooked.imageUrl != null
                                    ? NetworkImage(cooked.imageUrl!)
                                    : null,
                                child: cooked.imageUrl == null
                                    ? Text(
                                        cooked.name.substring(0, 1),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      )
                                    : null,
                                backgroundColor: HexColor("#97A78D"),
                              ),
                              title: Text(
                                cooked.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: HexColor("#2C4340"),
                                ),
                              ),
                              subtitle: Text(
                                "since ${cooked.startDate}",
                              ),
                              trailing: Text(cooked.isExpired!),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const AddFoodPage(foodType: "cooked"),
                  ),
                ).then((_) => _refreshFood());
              },
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: HexColor("#D9D9D9"),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Icon(
                    Icons.add_circle_outline_rounded,
                    size: 28,
                    color: HexColor("#2C4340"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditFoodDialog extends StatefulWidget {
  final Food food;

  const EditFoodDialog({super.key, required this.food});

  @override
  State<EditFoodDialog> createState() => _EditFoodDialogState();
}

class _EditFoodDialogState extends State<EditFoodDialog> {
  late TextEditingController _nameController;
  late DateTime _startDate;
  DateTime? _expDate;
  File? selectedImage; // To store the new selected image

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.food.name);
    _startDate = DateFormat('dd/MM/yyyy').parse(widget.food.startDate);
    if (widget.food.expDate != null) {
      _expDate = DateFormat('dd/MM/yyyy').parse(widget.food.expDate!);
    } else {
      _expDate = null;
    }
  }

  Future<String?> _uploadImageToFirebase(File image) async {
    try {
      // Generate a unique file name
      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload the image to Firebase Storage
      final ref = FirebaseStorage.instance.ref().child(fileName);
      await ref.putFile(image);

      // Get the download URL
      return await ref.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      return null;
    }
  }

  Future<void> _updateFood() async {
    String? imageUrl =
        widget.food.imageUrl; // Keep the current image URL by default

    // If a new image is selected, upload it and get the new URL
    if (selectedImage != null) {
      imageUrl = await _uploadImageToFirebase(selectedImage!);
    }

    // Update the food document in Firestore
    await FirebaseFirestore.instance
        .collection('food')
        .doc(widget.food.fid)
        .update({
      'name': _nameController.text,
      'startDate': Timestamp.fromDate(_startDate),
      'expDate': _expDate != null ? Timestamp.fromDate(_expDate!) : null,
      'imageUrl': imageUrl, // Update the image URL (new or existing)
    });

    Navigator.of(context).pop();
  }

  Future<void> _pickDate(bool isStartDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : (_expDate ?? _startDate),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_expDate != null && _expDate!.isBefore(picked)) {
            _expDate = null;
          }
        } else {
          _expDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit ${widget.food.name}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Text(
                  'Start Date: ${DateFormat('dd/MM/yyyy').format(_startDate)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: HexColor("#2C4340"),
                    fontSize: 14,
                  )),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _pickDate(true),
              ),
            ),
            ListTile(
              title: Text(
                  _expDate == null
                      ? 'Expiration Date: Not set'
                      : 'Expiration Date: ${DateFormat('dd/MM/yyyy').format(_expDate!)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: HexColor("#2C4340"),
                    fontSize: 14,
                  )),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _pickDate(false),
              ),
            ),
            const SizedBox(height: 20),
            // Display the current image or allow selecting a new one
            if (widget.food.imageUrl != null && selectedImage == null)
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(widget.food.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            if (selectedImage != null)
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: FileImage(selectedImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () async {
                final File? image = await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const CameraUI(),
                  ),
                );
                if (image != null) {
                  setState(() {
                    selectedImage = image; // Update the selected image
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              )),
        ),
        ElevatedButton(
          onPressed: _updateFood,
          style: ElevatedButton.styleFrom(
            backgroundColor: HexColor("#ADB2D4"),
          ),
          child: Text('Save Changes',
              style: TextStyle(
                color: HexColor("#2C4340"),
                fontWeight: FontWeight.bold,
              )),
        ),
      ],
    );
  }
}

// const List<String> _ingredientFilter = [
//   "earliest exp date",
//   "lastest purchase",
//   "oldest purchase"
// ];

// class IngredientDropdown extends StatefulWidget {
//   const IngredientDropdown({super.key});

//   @override
//   State<IngredientDropdown> createState() => _IngredientDropdownState();
// }

// class _IngredientDropdownState extends State<IngredientDropdown> {
//   String dropdownValue = _ingredientFilter.first;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: HexColor("#EEF1DA"),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: DropdownButton<String>(
//         value: dropdownValue,
//         icon: Padding(
//           padding: const EdgeInsets.only(left: 8.0),
//           child: Icon(Icons.filter_list),
//         ),
//         elevation: 16,
//         isDense: true,
//         borderRadius: BorderRadius.circular(20),
//         dropdownColor: HexColor("#EEF1DA"),
//         onChanged: (String? value) {
//           setState(() => dropdownValue = value!);
//         },
//         items: _ingredientFilter.map<DropdownMenuItem<String>>(
//           (String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 14,
//                 ),
//               ),
//             );
//           },
//         ).toList(),
//       ),
//     );
//   }
// }
