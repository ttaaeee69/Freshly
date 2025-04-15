import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freshly/pages/fridge/add_ingredient.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../models/ingredient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FridgePage extends StatefulWidget {
  const FridgePage({super.key});

  @override
  State<FridgePage> createState() => _FridgePageState();
}

class _FridgePageState extends State<FridgePage> {
  List<Ingredient> _ingredients = [];

  @override
  void initState() {
    super.initState();
    _refreshIngredients();
  }

  Future<void> _refreshIngredients() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("ingredients")
        .orderBy("startDate")
        .get();

    List<Ingredient> loadedIngredients = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      loadedIngredients.add(
        Ingredient(
          name: data["name"],
          startDate: data["startDate"].toDate(),
        ),
      );
    }

    setState(() => _ingredients = loadedIngredients);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd/MM/yyyy');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          // Remove the invalid spacing parameter
          children: [
            Container(
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
                        Row(
                          children: [
                            IngredientDropdown(),
                            IconButton(
                              icon: Container(
                                decoration: BoxDecoration(
                                  color: HexColor("#EEF1DA"),
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.edit_rounded,
                                    size: 20,
                                    color: HexColor("#97A78D"),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Don't use Expanded here since the container has no fixed height
                    _ingredients.isEmpty
                        ? const Center(
                            child: Text("ไม่มีข้อมูล"),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _ingredients.length,
                            itemBuilder: (context, index) {
                              final ingredient = _ingredients[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: HexColor("#EEF1DA"),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Text(
                                      ingredient.name.substring(0, 1),
                                    ),
                                  ),
                                  title: Text(
                                    ingredient.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: HexColor("#2C4340"),
                                    ),
                                  ),
                                  subtitle: Text(
                                    "since ${dateFormatter.format(ingredient.startDate)}",
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
                            builder: (context) => const AddIngredientPage(),
                          ),
                        );
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
            ),
            const SizedBox(height: 30), // Add spacing between containers
            Container(
              decoration: BoxDecoration(
                color: HexColor("#ADB2D4"),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
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
                        Row(
                          children: [
                            IngredientDropdown(),
                            IconButton(
                              icon: Container(
                                decoration: BoxDecoration(
                                  color: HexColor("#EEF1DA"),
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.edit_rounded,
                                    size: 20,
                                    color: HexColor("#97A78D"),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const List<String> _ingredientFilter = [
  "earliest exp date",
  "lastest purchase",
  "oldest purchase"
];

class IngredientDropdown extends StatefulWidget {
  const IngredientDropdown({super.key});

  @override
  State<IngredientDropdown> createState() => _IngredientDropdownState();
}

class _IngredientDropdownState extends State<IngredientDropdown> {
  String dropdownValue = _ingredientFilter.first;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HexColor("#EEF1DA"),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Icon(Icons.filter_list),
        ),
        elevation: 16,
        isDense: true,
        borderRadius: BorderRadius.circular(20),
        dropdownColor: HexColor("#EEF1DA"),
        onChanged: (String? value) {
          setState(() => dropdownValue = value!);
        },
        items: _ingredientFilter.map<DropdownMenuItem<String>>(
          (String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
