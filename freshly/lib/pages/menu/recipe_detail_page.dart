import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class RecipeDetailPage extends StatelessWidget {
  final dynamic recipe; // Recipe data passed to this page

  const RecipeDetailPage({super.key, this.recipe});

  @override
  Widget build(BuildContext context) {
    // Extract recipe details
    final name = recipe["title"]; // Recipe title
    final ingredients = recipe["extendedIngredients"] ?? []; // Ingredients list
    final instructions =
        recipe["instructions"] ?? "No instructions available."; // Instructions

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
        padding: const EdgeInsets.all(30.0), // Page padding
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Card padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe Name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30), // Spacing

                // Ingredients Section
                Text(
                  "Ingredients",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10), // Spacing
                ingredients.isEmpty
                    ? const Text(
                        "No ingredients information available") // Show message if no ingredients
                    : ListView.builder(
                        shrinkWrap: true, // Prevent infinite height
                        physics:
                            const NeverScrollableScrollPhysics(), // Disable scrolling
                        itemCount: ingredients.length, // Number of ingredients
                        itemBuilder: (context, index) {
                          final ingredient = ingredients[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2.0), // Spacing between items
                            child: Text(
                              "-  ${ingredient["original"]}", // Display ingredient
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        },
                      ),

                const SizedBox(height: 30), // Spacing

                // Instructions Section
                const Text(
                  "Instructions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10), // Spacing
                if (instructions is String || instructions is List)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: (instructions is String
                            ? (instructions)
                                .split('\n') // Split string into steps
                            : (instructions as List)
                                .cast<String>()) // Handle list of steps
                        .where((line) =>
                            line.trim().isNotEmpty) // Remove empty lines
                        .map((step) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0), // Spacing between steps
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "-  ", // Bullet point
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      step.trim(), // Display step
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 1.4, // Line height
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  )
                else
                  const Text(
                      "No instructions available"), // Show message if no instructions
              ],
            ),
          ),
        ),
      ),
    );
  }
}
