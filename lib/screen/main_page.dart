import 'package:flutter/material.dart';
import 'package:redbus_project/screen/account/user_page.dart';
import 'package:redbus_project/screen/home/home_page.dart';
import 'package:redbus_project/screen/order/order_page.dart';
import 'package:redbus_project/screen/promo/promo_page.dart';
import 'package:redbus_project/screen/ticket/ticket_page.dart';
import 'package:redbus_project/utils/theme.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  // Variables to store filters
  String? selectedFrom;
  String? selectedTo;
  String? selectedDate;

  // Method to update filters from HomePage
  void updateFilters(String from, String to, String date) {
    setState(() {
      selectedFrom = from;
      selectedTo = to;
      selectedDate = date;
      currentIndex = 2; // Navigate to TicketPage
    });
  }

  void resetFilters() {
    setState(() {
      selectedFrom = "";
      selectedTo = "";
      selectedDate = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    List<IconData> menu = [
      Icons.home,
      Icons.checklist,
      Icons.fireplace,
      Icons.account_circle_rounded,
    ];

    Widget body() {
      switch (currentIndex) {
        case 0:
          return HomePage(
            updateFilters: updateFilters,
          );
        case 1:
          return OrderPage();
        case 2:
          return TicketPage(
            from: selectedFrom,
            to: selectedTo,
            date: selectedDate,
          );
        case 3:
          return UserPage();
        default:
          return Container(
            child: Center(
              child: Text('hahahaha'),
            ),
          );
      }
    }

    Widget customBottomNav() {
      return BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (value) {
            setState(() {
              resetFilters();
              currentIndex = value;
            });
          },
          items: List.generate(menu.length, (index) {
            return BottomNavigationBarItem(
              label: '',
              activeIcon: Container(
                padding: EdgeInsets.all(5),
                decoration:
                    BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                child: Icon(menu[index], color: Colors.white),
              ),
              icon: Icon(
                menu[index],
                color: currentIndex == index ? Colors.white : secondaryColor1,
              ),
            );
          }));
    }

    return Scaffold(
      // appBar: AppBar(),
      body: body(),
      bottomNavigationBar: customBottomNav(),
    );
  }
}
