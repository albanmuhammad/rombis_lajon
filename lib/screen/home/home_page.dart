import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redbus_project/model/bus/bus.dart';
import 'package:redbus_project/screen/home/bus_page.dart';
import 'package:redbus_project/screen/ticket/ticket_page.dart';
import 'package:redbus_project/services/bus_service.dart';
import 'package:redbus_project/utils/theme.dart';
import 'package:redbus_project/widgets/offering_card.dart';
import 'package:redbus_project/widgets/promo_card.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final Function(String, String, String) updateFilters;

  HomePage({required this.updateFilters});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _toController = TextEditingController();
  TextEditingController _fromController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    // getData();
    super.initState();
  }

  // getData() async {
  //   buses = await BusService().getAllBus(context);
  //   print(buses);
  // }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget SearchSchedule() {
      return Column(
        children: [
          // Bus & Shuttle Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24),
                Text(
                  "Tiket Bus & Shuttle",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Selalu lebih murah dari harga loket",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _fromController,
                  decoration: InputDecoration(
                    labelText: 'Dari',
                    prefixIcon: Icon(Icons.directions_bus),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _toController,
                  decoration: InputDecoration(
                    labelText: 'Ke',
                    prefixIcon: Icon(Icons.directions_bus_filled),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _dateController,
                  readOnly:
                      true, // prevent keyboard input, only allow date picker
                  decoration: InputDecoration(
                    labelText: 'Tanggal Perjalanan',
                    prefixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context), // show date picker
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedDate = DateTime.now();
                              _dateController.text =
                                  DateFormat('yyyy-MM-dd').format(selectedDate);
                            });
                          },
                          child: Text('Hari Ini'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedDate =
                                  DateTime.now().add(Duration(days: 1));
                              _dateController.text =
                                  DateFormat('yyyy-MM-dd').format(selectedDate);
                            });
                          },
                          child: Text('Besok'),
                        ),
                      ],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    widget.updateFilters(_fromController.text,
                        _toController.text, _dateController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    // primary: Colors.red,
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, color: Colors.white),
                      SizedBox(width: 10),
                      Text("Cari bus", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget PromoHome() {
      return Container(
        color: primaryColor,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              "Daftar Bus",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Temukan Bus Langganan ana",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Cari",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PromoCard(
                  discount: '30% off',
                  route: 'Rute bus',
                  icon: Icons.directions_bus,
                ),
                PromoCard(
                  discount: '12% off',
                  route: 'Rute shuttle',
                  icon: Icons.directions_bus_filled,
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BusPage()));
              },
              style: ElevatedButton.styleFrom(
                // primary: Colors.red,
                backgroundColor: whiteColor,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Center(
                  child: Text(
                "Cari bus",
              )),
            ),
          ],
        ),
      );
    }

    // Widget OfferingSection() {
    //   return Column(
    //     children: [
    //       Padding(
    //         padding: EdgeInsets.symmetric(horizontal: 16),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Text(
    //               "Penawaran",
    //               style: TextStyle(
    //                 fontSize: 18,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //             TextButton(
    //               onPressed: () {
    //                 // Add your action here
    //               },
    //               child: Text(
    //                 "Lihat semua",
    //                 style: TextStyle(
    //                   color: Colors.blue,
    //                   fontSize: 16,
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //       Container(
    //         height: 150, // Adjust height based on your design
    //         child: ListView(
    //           scrollDirection: Axis.horizontal,
    //           children: [
    //             OfferingCard(
    //               title: "Special Offer",
    //               description: "Get the best deals for your trip.",
    //               imageUrl: '', // Replace with actual image path
    //             ),
    //             OfferingCard(
    //               title: "Merchandise Promo",
    //               description: "Enjoy up to 50% off on selected items.",
    //               imageUrl: '', // Replace with actual image path
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   );
    // }

    return ListView(
      children: [
        //search schedule
        SearchSchedule(),
        SizedBox(height: 20),
        //promo section
        PromoHome(),
        //offering
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
