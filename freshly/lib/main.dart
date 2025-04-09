import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/home_page.dart';
import 'pages/fridge_page.dart';
import 'pages/menu_page.dart';
import 'pages/account_page.dart';

void main() {
  runApp(const Freshly());
}

class Freshly extends StatelessWidget {
  const Freshly({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Freshly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: HexColor("#EEF1DA"),
        appBarTheme: AppBarTheme(
          backgroundColor: HexColor('#ADB2D4'),
          titleTextStyle: TextStyle(
            color: HexColor("#2C4340"),
          ),
        ),
        textTheme: GoogleFonts.outfitTextTheme(),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      home: const PageNavigator(),
    );
  }
}

class PageNavigator extends StatefulWidget {
  const PageNavigator({super.key});

  @override
  State<PageNavigator> createState() => _PageNavigatorState();
}

class _PageNavigatorState extends State<PageNavigator> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
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
          icon: const Icon(
            Icons.account_circle_rounded,
            size: 60,
            color: Colors.black,
          ),
          onPressed: () {},
          padding: const EdgeInsets.only(left: 20),
        ),
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2.0,
            children: [
              if (_selectedIndex == 0)
                const Text(
                  "Hi Onnicha Intuwattakul!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (_selectedIndex == 0)
                const Text(
                  "Welcome back",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              if (_selectedIndex == 1)
                const Text(
                  "Let's explore your fridge",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (_selectedIndex == 2)
                const Text(
                  "Find menu to cook ...",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (_selectedIndex == 3)
                const Text(
                  "Login / Sign up",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.circle_notifications_rounded, size: 40),
            onPressed: () {},
            padding: const EdgeInsets.only(right: 20),
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: NavigationBar(
          backgroundColor: HexColor("#ADB2D4"),
          animationDuration: const Duration(milliseconds: 500),
          indicatorShape: CircleBorder(
            side: BorderSide(
              color: HexColor("#E4C1C1"),
              width: 40,
            ),
          ),
          destinations: [
            NavigationDestination(
              icon: Image.asset(
                "assets/img/home_icon.PNG",
                width: 40,
                height: 40,
              ),
              label: "Home",
            ),
            NavigationDestination(
              icon: Image.asset(
                "assets/img/fridge_icon.PNG",
                width: 40,
                height: 40,
              ),
              label: "Fridge",
            ),
            NavigationDestination(
              icon: Image.asset(
                "assets/img/menu_icon.PNG",
                width: 40,
                height: 40,
              ),
              label: "Menu",
            ),
            NavigationDestination(
              icon: Image.asset(
                "assets/img/account_icon.PNG",
                width: 40,
                height: 40,
              ),
              label: "Account",
            ),
          ],
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          HomePage(),
          FridgePage(),
          MenuPage(),
          AccountPage(),
        ],
      ),
    );
  }
}
