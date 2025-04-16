import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'add_ingredient.dart';
import 'add_cooked.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../models/Food.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FridgePage extends StatefulWidget {
  const FridgePage({super.key});

  @override
  State<FridgePage> createState() => _FridgePageState();
}

class _FridgePageState extends State<FridgePage> {
  List<Food> _ingredients = [];
  List<Food> _cooked = [];

  @override
  void initState() {
    super.initState();
    _refreshFood();
  }

  String expCalculate(Timestamp startDate, Timestamp expDate) {
    DateTime start = startDate.toDate();
    DateTime exp = expDate.toDate();
    bool isExpired = start.isAfter(exp);

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
        .orderBy("startDate")
        .get();

    List<Food> loadedIngredients = [];
    List<Food> loadedCooked = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      Timestamp startDate = data["startDate"];
      DateTime star = startDate.toDate();
      String formatDate = DateFormat('dd/MM/yyyy').format(star);
      if (data["type"] == "ingredient") {
        loadedIngredients.add(
          Food(
            name: data["name"],
            startDate: formatDate,
            isExpired: data["expDate"] != null
                ? expCalculate(
                    startDate,
                    data["expDate"],
                  )
                : "",
            type: data["type"],
          ),
        );
      } else if (data["type"] == "cooked") {
        loadedCooked.add(Food(
          name: data["name"],
          startDate: formatDate,
          isExpired: data["expDate"] != null
              ? expCalculate(
                  startDate,
                  data["expDate"],
                )
              : "",
          type: data["type"],
        ));
      }
    }

    setState(() {
      _ingredients = loadedIngredients;
      _cooked = loadedCooked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
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
                                      "since ${ingredient.startDate}",
                                    ),
                                    trailing: Text(ingredient.isExpired!),
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
                      const SizedBox(height: 10),
                      _cooked.isEmpty
                          ? const Center(
                              child: Text("ไม่มีข้อมูล"),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _cooked.length,
                              itemBuilder: (context, index) {
                                final cooked = _cooked[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    color: HexColor("#EEF1DA"),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      child: Text(
                                        cooked.name.substring(0, 1),
                                      ),
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
                                );
                              },
                            ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const AddCookedPage(),
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
              ),
            ],
          ),
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
