import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              Text(
                "Hi Onnicha Intuwattakul!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Welcome back",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
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
                color: HexColor("#E4C1C1"),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            ),
          ],
        ),
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
                Text("Calendar - ${DateFormat('MMMM').format(shownMonth)}",
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

      dayWidgets.add(
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
