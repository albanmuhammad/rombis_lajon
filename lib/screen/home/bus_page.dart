import 'package:flutter/material.dart';
import 'package:redbus_project/model/bus/bus.dart';
import 'package:redbus_project/services/bus_service.dart';

class BusPage extends StatefulWidget {
  @override
  State<BusPage> createState() => _BusPageState();
}

class _BusPageState extends State<BusPage> {
  late ListBus? listBus;
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
    var x = await BusService().getAllBus(context);
    setState(() {
      listBus = x; // Update the listBus state when the data is fetched
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_sharp),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Daftar Bus'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: listBus!.data.length,
              itemBuilder: (context, index) {
                var bus = listBus!.data[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        // Bus Icon
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Icon(
                            Icons.directions_bus_sharp,
                            size: 60,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 16),
                        // Bus Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Bus Name
                              Text(
                                bus.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              // Bus Description
                              Text(
                                bus.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 8),
                              // Bus Route
                              Text(
                                "Route: " + bus.route.join(" → "),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8),
                              // Seat and Type Info
                              Row(
                                children: [
                                  Icon(Icons.event_seat,
                                      size: 18, color: Colors.black),
                                  SizedBox(width: 5),
                                  Text(
                                    "${bus.seat} seats, ${bus.type}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
