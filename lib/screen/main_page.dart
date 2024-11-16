import 'package:flutter/material.dart';
import 'package:redbus_project/screen/account/user_page.dart';
import 'package:redbus_project/screen/home/home_page.dart';
import 'package:redbus_project/screen/order/order_page.dart';
import 'package:redbus_project/screen/promo/promo_page.dart';
import 'package:redbus_project/screen/ticket/ticket_page.dart';
import 'package:redbus_project/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  final int? index;
  final String? busId;
  final int? tabIndex;
  const MainPage({this.index, this.busId, this.tabIndex});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    currentIndex = widget.index != null ? widget.index! : 0;
    selectedBus = widget.busId != null ? widget.busId! : "";
    super.initState();
  }

  int currentIndex = 0;
  bool showNumbers = false;
  final List<String> phoneNumbers = ['+628164231047', '+6285669248898'];
  final List<String> namaNomer = ['Pak Bambang', 'Pak Gusman'];

  // Variables to store filters
  String? selectedFrom;
  String? selectedTo;
  String? selectedDate;
  String? selectedBus;

  // Method to update filters from HomePage
  void updateFilters(String from, String to, String date, String busId) {
    // widget.updateFilters!(from, to, date, busId);
    setState(() {
      selectedFrom = from;
      selectedTo = to;
      selectedDate = date;
      selectedBus = busId;
      currentIndex = 2; // Navigate to TicketPage
    });
  }

  Future<void> openWhatsApp(String phoneNumber) async {
    final String phone = phoneNumber.replaceFirst('+', '');
    final Uri url = Uri.parse('https://wa.me/$phone');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching WhatsApp: $e');
    }
  }

  void resetFilters() {
    setState(() {
      selectedFrom = "";
      selectedTo = "";
      selectedDate = "";
      selectedBus = "";
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
          return OrderPage(initialTabIndex: widget.tabIndex ?? 0);
        case 2:
          return TicketPage(
            from: selectedFrom,
            to: selectedTo,
            date: selectedDate,
            busId: selectedBus,
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
      body: Stack(
        children: [
          body(),
          Positioned(
            right: 16,
            bottom: 32,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showNumbers)
                  Column(
                    children: List.generate(phoneNumbers.length, (index) {
                      final phoneNumber = phoneNumbers[index];
                      final name = namaNomer[
                          index]; // Match name with corresponding phone number

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: ElevatedButton(
                            onPressed: () => openWhatsApp(phoneNumber),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          4), // Space between name and phone number row
                                  Row(
                                    mainAxisSize: MainAxisSize
                                        .min, // Adjusts button width to content
                                    children: [
                                      Icon(Icons.phone, color: Colors.white),
                                      SizedBox(
                                          width:
                                              8), // Space between icon and phone number
                                      Text(
                                        phoneNumber,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      showNumbers = !showNumbers;
                    });
                  },
                  child: Icon(Icons.phone, color: Colors.white),
                  backgroundColor: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: customBottomNav(),
    );
  }
}
