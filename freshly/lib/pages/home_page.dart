import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          spacing: 30,
          children: [
            Container(
              height: 386,
              decoration: BoxDecoration(
                color: HexColor("#E4C1C1"),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Calendar(),
            ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: HexColor("#97A78D"),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      "Don't forget this food without expiration date",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
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

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final PageController _pageController = PageController(initialPage: 0);
  final DateTime _currentDate = DateTime.now();
  int _currentMonthOffset = 0;

  @override
  Widget build(BuildContext context) {
    DateTime shownMonth = DateTime(
      _currentDate.year,
      _currentDate.month + _currentMonthOffset,
    );
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Calendar - ${DateFormat('MMMM yyyy').format(shownMonth)}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                .map((day) =>
                    Text(day, style: TextStyle(fontWeight: FontWeight.bold)))
                .toList(),
          ),
          SizedBox(
            height: 300,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(
                  () => _currentMonthOffset = index,
                );
              },
              itemBuilder: (context, index) {
                DateTime month = DateTime(
                  _currentDate.year,
                  _currentDate.month + index,
                );
                return buildCalendar(month);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCalendar(DateTime month) {
    int daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
    int startingWeekday = firstDayOfMonth.weekday % 7;

    List<Widget> dayWidgets = [];

    for (int i = 0; i < startingWeekday; i++) {
      dayWidgets.add(Container());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      bool isToday = (month.year == DateTime.now().year &&
          month.month == DateTime.now().month &&
          day == DateTime.now().day);

      // Example Dots
      // Change this logic later
      bool showDot = (day % 5 == 0);

      dayWidgets.add(
        Stack(
          children: [
            Container(
              margin: EdgeInsets.all(8),
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
            if (showDot)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      padding: EdgeInsets.all(16),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: dayWidgets,
    );
  }
}
