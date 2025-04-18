import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:dio/dio.dart';
import 'recipe_detail_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final String apiKey =
      "54b2b8be87124363836179e73a645e7d"; // Replace with your API key
  Dio dio = Dio();
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> recipes = [];
  String mealType = "breakfast"; // Default meal type

  @override
  void initState() {
    super.initState();
    determineMealType(); // Determine the meal type based on the time of day
    // fetchRecipes(""); // Fetch random recipes for the determined meal type
  }

  void determineMealType() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) {
      mealType = "breakfast";
    } else if (hour >= 11 && hour < 17) {
      mealType = "lunch";
    } else {
      mealType = "dinner";
    }
  }

  Future<void> fetchRecipes(String query) async {
    try {
      if (query.isNotEmpty) {
        // Perform search and get recipe IDs
        final searchResponse = await dio.get(
          "https://api.spoonacular.com/recipes/complexSearch?apiKey=$apiKey&query=$query&number=10&maxReadyTime=15&minServings=1&maxServings=2",
        );
        List<dynamic> searchResults = searchResponse.data["results"];

        // Fetch detailed information for each recipe
        List<dynamic> detailedRecipes = [];
        for (var recipe in searchResults) {
          int id = recipe['id'];
          try {
            final detailResponse = await dio.get(
              "https://api.spoonacular.com/recipes/$id/information?apiKey=$apiKey&includeNutrition=false",
            );
            detailedRecipes.add(detailResponse.data);
          } catch (e) {
            print("Error fetching details for recipe $id: $e");
          }
        }

        setState(() {
          recipes = detailedRecipes;
        });
      } else {
        // Fetch random recipes for the meal type
        final response = await dio.get(
          "https://api.spoonacular.com/recipes/random?apiKey=$apiKey&number=10&tags=$mealType&maxReadyTime=15&minServings=1&maxServings=2",
        );
        setState(() {
          recipes = response.data["recipes"];
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch recipes")),
      );
    }
  }

  void searchMenu() {
    String searchText = _searchController.text.trim();
    fetchRecipes(searchText); // Fetch recipes based on the search text
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for menu by ingredient . . .',
                labelStyle: TextStyle(
                  color: HexColor("#8F9E85"),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                isDense: true,
                filled: true,
                fillColor: HexColor("#DEDEDE"),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                suffixIcon: IconButton(
                  onPressed: searchMenu,
                  icon: Icon(
                    Icons.search,
                    color: HexColor("#8F9E85"),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              "Recommended Recipes for $mealType:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: recipes.isEmpty
                ? const Center(child: Text("No recipes found"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      final name = recipe['title'];
                      final imageUrl = recipe["image"];
                      final ingredients = recipe['extendedIngredients']
                              ?.map<Widget>(
                                (ingredient) => Text(
                                  "-  ${ingredient['original']}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              )
                              ?.toList() ??
                          [
                            const Text(
                              "No ingredients available",
                            )
                          ];
                      final List<Color> cardColors = [
                        HexColor("#E4C1C1"), // Light orange
                        HexColor("#97A78D"), // Light green
                        HexColor("#ADB2D4"), // Light blue
                      ];
                      final backgroundColor =
                          cardColors[index % cardColors.length];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      RecipeDetailPage(recipe: recipe)));
                        },
                        child: Card(
                          color: backgroundColor,
                          margin: const EdgeInsets.only(bottom: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                bottom: 16.0,
                                top: 8.0),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(
                                          name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow
                                              .ellipsis, // Handle long names
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Recipe Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        imageUrl,
                                        height: 128,
                                        width: 128,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            height: 100,
                                            width: 100,
                                            color: Colors.grey,
                                            child: const Center(
                                              child: Text(
                                                "Image not available",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                        width:
                                            16), // Spacing between image and text
                                    // Recipe Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Ingredients
                                          Text(
                                            "Ingredients:",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: ingredients,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
