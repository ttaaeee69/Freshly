import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../../models/food.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user = FirebaseAuth.instance.currentUser!; // Get the current user

  // Stream to fetch food data from Firestore
  Stream<QuerySnapshot> getFoodStream() {
    return FirebaseFirestore.instance
        .collection("food")
        .where("uid", isEqualTo: user.uid) // Filter by user ID
        .orderBy("startDate", descending: true) // Order by start date
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            spacing: 30, // Spacing between elements
            children: [
              // Calendar container
              Container(
                height: 400,
                decoration: BoxDecoration(
                  color: HexColor("#E4C1C1"), // Background color
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: getFoodStream(), // Fetch food data
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Calendar(foods: []); // Show empty calendar
                    }
                    final foods = snapshot.data?.docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return Food(
                            uid: user.uid,
                            fid: doc.id,
                            name: data['name'],
                            startDate: DateFormat('dd/MM/yyyy').format(
                                (data['startDate'] as Timestamp).toDate()),
                            expDate: data['expDate'] != null
                                ? DateFormat('dd/MM/yyyy').format(
                                    (data['expDate'] as Timestamp).toDate())
                                : null,
                          );
                        }).toList() ??
                        [];

                    return Calendar(
                        foods: foods.where((f) => f.expDate != null).toList());
                  },
                ),
              ),

              // Food list container
              Container(
                decoration: BoxDecoration(
                  color: HexColor("#97A78D"), // Background color
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Title
                      Text(
                        "Don't forget these food without expiration date",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10), // Spacing
                      StreamBuilder(
                        stream: getFoodStream(), // Fetch food data
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child:
                                    CircularProgressIndicator()); // Loading indicator
                          }

                          if (snapshot.hasError) {
                            return const Center(
                                child: Text("Error")); // Error message
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                                child:
                                    Text("No food found")); // No data message
                          }

                          final foodDocs = snapshot.data!.docs;

                          return ListView.builder(
                            shrinkWrap: true, // Prevent infinite height
                            physics:
                                const NeverScrollableScrollPhysics(), // Disable scrolling
                            itemCount: foodDocs.length, // Number of items
                            itemBuilder: (context, index) {
                              final data = foodDocs[index].data()
                                  as Map<String, dynamic>; // Cast to Map
                              Timestamp startDate = data["startDate"];
                              DateTime star = startDate.toDate();
                              String? imageUrl = data.containsKey("imageUrl")
                                  ? data["imageUrl"]
                                  : null; // Check if imageUrl exists
                              String formatDate =
                                  DateFormat('dd/MM/yyyy').format(star);

                              final food = Food(
                                uid: user.uid,
                                fid: foodDocs[index].id,
                                name: data["name"],
                                startDate: formatDate,
                                imageUrl: imageUrl,
                              );

                              return Container(
                                child: data["expDate"] == null
                                    ? Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                          color: HexColor(
                                              "#EFE1DA"), // Background color
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: food.imageUrl !=
                                                    null
                                                ? NetworkImage(food
                                                    .imageUrl!) // Use the image if available
                                                : null, // Fallback to no image
                                            backgroundColor: HexColor(
                                                "#97A78D"), // Background color for the text
                                            child: food.imageUrl == null
                                                ? Text(
                                                    food.name.substring(0,
                                                        1), // Show the first letter if no image
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : null, // No child if the image is available
                                          ),
                                          title: Text(
                                            food.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: HexColor("#2C4340"),
                                            ),
                                          ),
                                          subtitle: Text(
                                            "Since ${food.startDate}",
                                            style: TextStyle(
                                              color: HexColor("#2C4340"),
                                            ),
                                          ),
                                        ),
                                      )
                                    : null, // Skip if expDate exists
                              );
                            },
                          );
                        },
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

// Calendar widget to display food expiration dates
class Calendar extends StatefulWidget {
  final List<Food> foods; // List of food items
  const Calendar({super.key, required this.foods});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final PageController _pageController =
      PageController(initialPage: 0); // Page controller
  final DateTime _currentDate = DateTime.now(); // Current date
  int _currentMonthOffset = 0; // Offset for the displayed month

  @override
  Widget build(BuildContext context) {
    // Calculate the currently shown month based on the offset
    DateTime shownMonth = DateTime(
      _currentDate.year,
      _currentDate.month + _currentMonthOffset,
    );

    return SafeArea(
      child: Column(
        children: [
          // Month navigation
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Show the left arrow only if the offset is greater than 0
                if (_currentMonthOffset > 0)
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      // Navigate to the previous month
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  )
                else
                  const SizedBox(width: 48), // Placeholder for alignment
                Text(
                  "Calendar - ${DateFormat('MMMM yyyy').format(shownMonth)}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    // Navigate to the next month
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ],
            ),
          ),

          // Weekday labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                .map((day) => Text(day,
                    style: const TextStyle(fontWeight: FontWeight.bold)))
                .toList(),
          ),

          // Calendar grid
          SizedBox(
            height: 300,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentMonthOffset = index; // Update month offset
                });
              },
              itemBuilder: (context, index) {
                // Calculate the month based on the index
                DateTime month = DateTime(
                  _currentDate.year,
                  _currentDate.month + index,
                );
                return buildCalendar(month); // Build calendar for the month
              },
            ),
          ),
        ],
      ),
    );
  }

  // Build the calendar grid for a specific month
  Widget buildCalendar(DateTime month) {
    int daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
    int startingWeekday = firstDayOfMonth.weekday % 7;

    List<Widget> dayWidgets = [];

    // Add empty containers for days before the first day of the month
    for (int i = 0; i < startingWeekday; i++) {
      dayWidgets.add(Container());
    }

    // Add day widgets for each day in the month
    for (int day = 1; day <= daysInMonth; day++) {
      final currentDay = DateTime(month.year, month.month, day);
      bool isToday = DateUtils.isSameDay(currentDay, DateTime.now());

      // Check if any food expires on this day
      bool hasExpiringFood = widget.foods.any((food) {
        try {
          if (food.expDate == null) return false;
          final expDate = DateFormat('dd/MM/yyyy').parse(food.expDate!);
          return expDate.year == currentDay.year &&
              expDate.month == currentDay.month &&
              expDate.day == currentDay.day;
        } catch (e) {
          return false;
        }
      });

      dayWidgets.add(
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isToday ? HexColor("#ADB2D4") : HexColor("#EEF1DA"),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  "$day",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isToday ? HexColor("#EEF1DA") : HexColor("#2C4340"),
                  ),
                ),
              ),
            ),
            if (hasExpiringFood)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red, // Indicator for expiring food
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7, // 7 days in a week
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(), // Disable scrolling
      shrinkWrap: true,
      children: dayWidgets,
    );
  }
}
