import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class RecipeDetailPage extends StatelessWidget {
  final dynamic recipe;

  const RecipeDetailPage({super.key, this.recipe});

  @override
  Widget build(BuildContext context) {
    final name = recipe["title"];
    final imageUrl = recipe["image"];
    final ingredients = recipe["extendedIngredients"] ?? [];
    final instructions = recipe["instructions"] ?? "No instructions available.";

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: HexColor("#2C4340"),
          onPressed: () => Navigator.pop(context),
          padding: const EdgeInsets.only(left: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Recipe Name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // Ingredients Section
                Text(
                  "Ingredients",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ingredients.isEmpty
                    ? const Text("No ingredients information available")
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: ingredients.length,
                        itemBuilder: (context, index) {
                          final ingredient = ingredients[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Text(
                              "-  ${ingredient["original"]}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        },
                      ),

                // Instructions Section
                const Text(
                  "Instructions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                if (instructions is String || instructions is List)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: (instructions is String
                            ? (instructions).split('\n')
                            : (instructions as List).cast<String>())
                        .where((line) => line.trim().isNotEmpty)
                        .map((step) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "-  ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      step.trim(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  )
                else
                  const Text("No instructions available"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
