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
  final Function(String, String, String, String) updateFilters;

  HomePage({required this.updateFilters});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _toController = TextEditingController();
  TextEditingController _fromController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  late ListBus? buses;
  bool isLoading = false;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    buses = await BusService().getAllBus(context);
    setState(() {
      isLoading = false;
    });
    print(buses);
  }

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
        mainAxisAlignment: MainAxisAlignment.center,
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
                SizedBox(height: 8),
                Text(
                  "Tiket Bus & Shuttle",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    widget.updateFilters(_fromController.text,
                        _toController.text, _dateController.text, '');
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
                      Text("Cari Tiket", style: TextStyle(color: Colors.white)),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(height: 10),
            Text(
              "Daftar Bus",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Temukan Bus",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            isLoading
                ? CircularProgressIndicator() // Show loading state
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: buses != null
                        ? buses!.data
                            .map((bus) {
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    widget.updateFilters(
                                        _fromController.text,
                                        _toController.text,
                                        _dateController.text,
                                        bus.id);
                                  },
                                  child: PromoCard(
                                    discount:
                                        '${bus.name}', // Assuming the bus has a discount property
                                    route: bus
                                        .type, // Assuming the bus has a route property
                                    icon: Icons
                                        .directions_bus, // Adjust this if needed
                                  ),
                                ),
                              );
                            })
                            .take(2)
                            .toList()
                        : [],
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
                "Cari Bus Lainnya",
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

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          //search schedule
          // SizedBox(height: 24),
          Expanded(child: SearchSchedule()),
          // SizedBox(height: 24),
          // SizedBox(height: 32),
          //promo section
          Expanded(child: PromoHome()),
          //offering
          // SizedBox(
          //   height: 10,
          // ),
        ],
      ),
    );
  }
}
