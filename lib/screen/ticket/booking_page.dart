import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart'; // Import for currency formatting
import 'package:redbus_project/model/bus/bus.dart';
import 'package:redbus_project/services/auth_service.dart';
import 'package:redbus_project/services/bus_service.dart';
import 'package:redbus_project/services/ticket_service.dart';

class BookingPage extends StatefulWidget {
  final String? busId;
  final String? ticketId;

  BookingPage({this.busId, this.ticketId});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  BusDetail? busDetail;
  String? busId;
  String? ticketId;
  List<int> selectedSeats = [];
  int totalPrice = 0;
  String? departureRoute;
  String? departureTime;
  String? userIdAccount;
  String? selectedDestination;
  String? selectedDestinationTime;

  @override
  void initState() {
    busId = widget.busId;
    ticketId = widget.ticketId;
    getData();
    super.initState();
  }

  getData() async {
    var bus = await BusService().getBusDetail(context, busId!);
    var userId = await AuthService().getUserId();
    setState(() {
      busDetail = bus;
      userIdAccount = userId;
      selectedDestination = busDetail!
          .route.last; // Set the initial route to the last destination
      departureRoute = busDetail!.route.first;
    });
  }

  Widget buildSeatLayout() {
    if (busDetail == null) return Container();

    // Define the number of columns based on bus type
    int columns;
    double columnSpacing;

    switch (busDetail!.type) {
      case '1x1':
        columns = 2; // 2 columns
        columnSpacing = 16.0; // Spacing between columns
        break;
      case '1x2':
        columns = 3; // 3 columns
        columnSpacing = 16.0; // Spacing between columns
        break;
      case '2x2':
        columns = 4; // 4 columns
        columnSpacing = 16.0; // Spacing between columns
        break;
      case '2x3':
        columns = 5; // 5 columns
        columnSpacing = 16.0; // Spacing between columns
        break;
      default:
        columns = 4;
        columnSpacing = 16.0; // Default spacing
    }

    // Filled seats from the ticket
    List<int> filledSeats = [];
    var ticket = busDetail!.ticket.firstWhere((t) => t.id == ticketId);
    filledSeats.addAll(ticket.seat);

    // Number of total seats
    int totalSeats = busDetail!.seat;

    // Create the seat layout
    List<Widget> seatRows = [];
    for (int rowIndex = 0;
        rowIndex < (totalSeats / columns).ceil();
        rowIndex++) {
      List<Widget> seatWidgets = [];
      for (int colIndex = 0; colIndex < columns; colIndex++) {
        int seatIndex = rowIndex * columns + colIndex;
        if (seatIndex >= totalSeats) break; // Exit if exceeding total seats

        bool isFilled = filledSeats.contains(seatIndex + 1);
        bool isSelected = selectedSeats.contains(seatIndex + 1);

        seatWidgets.add(
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: columnSpacing / 2,
              vertical: 4,
            ),
            child: GestureDetector(
              onTap: isFilled
                  ? null
                  : () {
                      setState(() {
                        if (isSelected) {
                          selectedSeats.remove(seatIndex + 1);
                        } else {
                          selectedSeats.add(seatIndex + 1);
                        }
                        calculateTotalPrice(ticket.price[
                            busDetail!.route.indexOf(selectedDestination!) -
                                1]);
                      });
                    },
              child: Container(
                width: 40, // Width of each seat container
                height: 40, // Height of each seat container
                decoration: BoxDecoration(
                  color: isFilled
                      ? Colors.red[400] // Filled seats
                      : isSelected
                          ? Colors.green[300] // Selected seats
                          : Colors.grey[300], // Available seats
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${seatIndex + 1}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }

      if (seatWidgets.isNotEmpty) {
        seatRows.add(
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: seatWidgets,
                ),
              ],
            ),
          ),
        );
      }
    }

    // Wrap the Column in a Center widget and a Container with padding
    return Center(
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 40),
        // color: Colors.amber,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: seatRows,
        ),
      ),
    );
  }

  // Calculate total price based on selected seats
  void calculateTotalPrice(int pricePerSeat) {
    setState(() {
      totalPrice = (pricePerSeat * selectedSeats.length) +
          selectedSeats.reduce((a, b) => a + b);
    });
  }

  String formatRupiah(int value) {
    final formatCurrency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatCurrency.format(value);
  }

  String formatBusDetailTime(String time) {
    // Parse the ISO 8601 string
    DateTime dateTime = DateTime.parse(time);

    // Format the date and time
    String formattedDate =
        DateFormat('dd-MM-yyyy').format(dateTime); // e.g., 03-10-2024
    String formattedTime = DateFormat('HH:mm').format(dateTime); // e.g., 22:25

    // Return formatted date and time
    return '|$formattedDate|\n|$formattedTime|'; // Add a newline character
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text('Konfirmasi', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Berangkat dari:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(departureRoute!),
                SizedBox(height: 8),
                Text('Tujuan:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(selectedDestination!),
                SizedBox(height: 8),
                Text('Kursi yang dipilih:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(selectedSeats.join(', ')),
                SizedBox(height: 8),
                Text('Total Harga:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(formatRupiah(totalPrice)),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Confirm', style: TextStyle(color: Colors.green)),
              onPressed: () async {
                // Handle the booking action
                var x = await ticketService().bookingTicket(
                    context,
                    userIdAccount!,
                    ticketId!,
                    totalPrice,
                    selectedSeats,
                    departureRoute!,
                    selectedDestination!);
                print(x);
                Navigator.of(context).pop();
                Navigator.of(context).pop(x);
              },
            ),
          ],
        );
      },
    );
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
        title: Text('Pemesanan Tiket'),
      ),
      body: busDetail == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Card(
                  margin: EdgeInsets.all(10.0),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bus: ${busDetail!.name}',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: [
                            Text(
                              'Total Kursi: ${busDetail!.seat}',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            SizedBox(width: 20),
                            Text(
                              'Kursi Terisisa: ${busDetail!.seat - busDetail!.ticket.firstWhere((t) => t.id == ticketId).seat.length}',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Dari'),
                                Text(
                                    formatBusDetailTime(
                                        '${busDetail!.ticket.firstWhere((t) => t.id == ticketId).time.first}'),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(Icons.arrow_forward, color: Colors.grey),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Ke'),
                                Text(
                                  formatBusDetailTime(
                                      '${busDetail!.ticket.firstWhere((t) => t.id == ticketId).time[busDetail!.route.indexOf(selectedDestination!)]}'), // End time
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                // End location
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(busDetail!.route[0],
                                style: TextStyle(color: Colors.grey)),
                            DropdownButton<String>(
                              style: TextStyle(color: Colors.grey),
                              value: selectedDestination,
                              items: busDetail!.route
                                  .sublist(1) // Skip the first index
                                  .map((route) => DropdownMenuItem<String>(
                                        value: route,
                                        child: Text(route),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedDestination = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        if (selectedDestination != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.0),
                              Row(
                                children: [
                                  Text(
                                    'Harga:',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  SizedBox(width: 10.0),
                                  SizedBox(width: 5.0),
                                  Text(
                                    formatRupiah(busDetail!.ticket
                                        .firstWhere((t) => t.id == ticketId)
                                        .price[busDetail!.route
                                            .indexOf(selectedDestination!) -
                                        1]),
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        SizedBox(height: 10.0),
                        Text(
                          'Total Harga: ${formatRupiah(totalPrice)}',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SingleChildScrollView(
                      child: buildSeatLayout(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: selectedSeats.isNotEmpty
                        ? () {
                            _showConfirmationDialog(context);
                          }
                        : null,
                    child: Text('Book Now', style: TextStyle(fontSize: 18.0)),
                  ),
                ),
              ],
            ),
    );
  }
}
