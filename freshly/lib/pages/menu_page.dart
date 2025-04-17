import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:dio/dio.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    super.initState();
    // fetchSpoonacularApi();
  }

  final String spoonacularApi =
      "https://api.spoonacular.com/recipes/complexSearch?apiKey=54b2b8be87124363836179e73a645e7d&query=chicken&number=1";

  Dio dio = Dio();

  // Future<void> fetchSpoonacularApi() async {
  //   try {
  //     final response = await dio.get(spoonacularApi);
  //     print(response.data);
  //   } catch (e) {
  //     print("Error fetching data: $e");
  //   }
  // }

  TextEditingController searchController = TextEditingController();

  void searchMenu() {
    String searchText = searchController.text;
    // Implement your search logic here
    print("Searching for: $searchText");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 40,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
            child: TextField(
              controller: searchController,
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
                  onPressed: () {
                    searchMenu();
                  },
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              "Recommend from you to have :",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
