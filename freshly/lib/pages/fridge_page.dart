import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class FridgePage extends StatelessWidget {
  const FridgePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          spacing: 30,
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
                  ],
                ),
              ),
            ),
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
