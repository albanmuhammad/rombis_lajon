import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart'; // Import for currency formatting
import 'package:redbus_project/model/auth/user.dart';
import 'package:redbus_project/model/bus/bus.dart';
import 'package:redbus_project/screen/ticket/payment_page.dart';
import 'package:redbus_project/services/auth_service.dart';
import 'package:redbus_project/services/bus_service.dart';
import 'package:redbus_project/services/ticket_service.dart';
import 'package:redbus_project/utils/utilities.dart';

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
  List<String> selectedTikum = [];
  String? selectedDestinationTime;
  List<String> seatName = [];
  String? userName;
  String? userGender;
  int quantity = 0; // Default quantity; this can be managed in state if needed
  List<TextEditingController> seatNameControllers = [];
  List<String> passengerGenders = [];
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc());
  String currentDateText = DateFormat('yyyy-MM-dd').format(DateTime.now());

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
    var userNameSp = await AuthService().getUserName();
    var userGenderSp = await AuthService().getUserGender();
    setState(() {
      busDetail = bus;
      userIdAccount = userId;
      selectedDestination = busDetail!
          .route.last; // Set the initial route to the last destination
      departureRoute = busDetail!.route.first;
      userName = userNameSp;
      userGender = userGenderSp;
    });
  }

  Widget buildSeatLayout() {
    if (busDetail == null) return Container();

    // Define the number of columns and layout pattern based on bus type
    int columns;
    double columnSpacing;
    List<int> seatPattern;

    switch (busDetail!.type) {
      case '1x1':
        columns = 2;
        columnSpacing = 16.0;
        seatPattern = [1, 0, 1];
        break;
      case '1x2':
        columns = 3;
        columnSpacing = 16.0;
        seatPattern = [1, 0, 1, 1];
        break;
      case '2x2':
        columns = 4;
        columnSpacing = 16.0;
        seatPattern = [1, 1, 0, 1, 1];
        break;
      case '2x3':
        columns = 6;
        columnSpacing = 16.0;
        seatPattern = [1, 1, 0, 1, 1, 1];
        break;
      default:
        columns = 4;
        columnSpacing = 16.0;
        seatPattern = [1, 1, 0, 1, 1];
    }

    // Filled seats from the ticket
    List<int> filledSeats = [];
    var ticket = busDetail!.ticket.firstWhere((t) => t.id == ticketId);
    filledSeats.addAll(ticket.seat);

    // Total seat count from busDetail
    int totalSeats = busDetail!.seat;
    int seatNumber = 1;

    // Create the seat layout
    List<Widget> seatRows = [];
    while (seatNumber <= totalSeats) {
      List<Widget> seatWidgets = [];
      for (int colIndex = 0; colIndex < seatPattern.length; colIndex++) {
        if (seatPattern[colIndex] == 1 && seatNumber <= totalSeats) {
          bool isFilled = filledSeats.contains(seatNumber);
          bool isSelected = selectedSeats.contains(seatNumber);
          int seatCorrespondingNumber = seatNumber;

          seatWidgets.add(
            GestureDetector(
              onTap: isFilled
                  ? null
                  : () {
                      setState(() {
                        if (isSelected) {
                          selectedSeats.remove(seatCorrespondingNumber);
                          seatNameControllers.removeLast();
                          passengerGenders.removeLast();
                          print("Seat $seatCorrespondingNumber deselected");
                        } else {
                          selectedSeats.add(seatCorrespondingNumber);
                          passengerGenders.add('laki');
                          seatNameControllers.add(TextEditingController());
                          print("Seat $seatCorrespondingNumber selected");
                        }

                        if (selectedSeats.isNotEmpty) {
                          calculateTotalPrice(ticket.price[
                              busDetail!.route.indexOf(selectedDestination!) -
                                  1]);
                        } else {
                          totalPrice = 0;
                        }

                        seatName =
                            List.generate(selectedSeats.length, (index) => '');
                        selectedTikum =
                            List.generate(selectedSeats.length, (index) => '');
                      });
                    },
              child: Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.symmetric(
                    horizontal: columnSpacing / 2, vertical: 4),
                decoration: BoxDecoration(
                  color: isFilled
                      ? Colors.red[400]
                      : isSelected
                          ? Colors.green[300]
                          : Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '$seatNumber',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          );

          seatNumber++; // Only increment when an actual seat is added
        } else {
          // Add an empty container to represent the gap
          seatWidgets.add(
            Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.symmetric(
                  horizontal: columnSpacing / 2, vertical: 4),
              color: Colors.transparent,
            ),
          );
        }
      }

      if (seatWidgets.isNotEmpty) {
        seatRows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: seatWidgets,
          ),
        );
      }
    }

    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: seatRows,
        ),
      ),
    );
  }

  Widget buildInputJumlahBarang() {
    return Center(
      child: Container(
        // height: MediaQuery.of(context).size.height * 0.36,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Jumlah Barang',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Masukkan jumlah barang yang ingin Anda kirim',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: quantity > 1
                      ? () {
                          setState(() {
                            quantity--;
                            calculateTotalPrice(busDetail!.ticket
                                    .firstWhere((t) => t.id == ticketId)
                                    .price[
                                busDetail!.route.indexOf(selectedDestination!) -
                                    1]);
                          });
                        }
                      : null,
                ),
                Container(
                  // margin: EdgeInsets.symmetric(horizontal: 16),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    controller:
                        TextEditingController(text: quantity.toString()),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    onChanged: (value) {
                      setState(() {
                        quantity = int.tryParse(value) ?? 1;
                        if (quantity < 1) {
                          quantity = 1; // Ensure non-zero value
                          calculateTotalPrice(busDetail!.ticket
                                  .firstWhere((t) => t.id == ticketId)
                                  .price[
                              busDetail!.route.indexOf(selectedDestination!) -
                                  1]);
                        } else if (quantity >
                            busDetail!.storage -
                                busDetail!.ticket
                                    .firstWhere((t) => t.id == ticketId)
                                    .jumlahBarang) {
                          quantity = busDetail!.storage -
                              busDetail!.ticket
                                  .firstWhere((t) => t.id == ticketId)
                                  .jumlahBarang; // Ensure non-zero value
                          calculateTotalPrice(busDetail!.ticket
                                  .firstWhere((t) => t.id == ticketId)
                                  .price[
                              busDetail!.route.indexOf(selectedDestination!) -
                                  1]);
                        }
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: quantity <
                          busDetail!.storage -
                              busDetail!.ticket
                                  .firstWhere((t) => t.id == ticketId)
                                  .jumlahBarang
                      ? () {
                          setState(() {
                            quantity++;
                            calculateTotalPrice(busDetail!.ticket
                                    .firstWhere((t) => t.id == ticketId)
                                    .price[
                                busDetail!.route.indexOf(selectedDestination!) -
                                    1]);
                          });
                        }
                      : () {
                          setState(() {
                            quantity = busDetail!.storage -
                                busDetail!.ticket
                                    .firstWhere((t) => t.id == ticketId)
                                    .jumlahBarang;
                            calculateTotalPrice(busDetail!.ticket
                                    .firstWhere((t) => t.id == ticketId)
                                    .price[
                                busDetail!.route.indexOf(selectedDestination!) -
                                    1]);
                          });
                        },
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              'Titik Pengumpulan Barang',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Masukkan titik kumpul yang ingin Anda kirim',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            Container(
              // margin: EdgeInsets.symmetric(horizontal: 16),
              width: MediaQuery.of(context).size.width * 0.6,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Titik Kumpul Barang',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
                style: TextStyle(color: Colors.black, fontSize: 16.0),
                icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                value: busDetail!.tikum[0],
                items: busDetail!.tikum.map((tikum) {
                  return DropdownMenuItem<String>(
                    value: tikum,
                    child: Text(tikum),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    busDetail!.ticket
                                .firstWhere((t) => t.id == ticketId)
                                .tipeIsi ==
                            'barang'
                        ? selectedTikum.add('')
                        : null;
                    selectedTikum[0] = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Calculate total price based on selected seats
  void calculateTotalPrice(int pricePerSeat) {
    setState(() {
      totalPrice =
          busDetail!.ticket.firstWhere((t) => t.id == ticketId).tipeIsi ==
                  'barang'
              ? (pricePerSeat * quantity)
              : (pricePerSeat * selectedSeats.length);
      // +selectedSeats.reduce((a, b) => a + b);
    });
  }

  String formatRupiah(int value) {
    final formatCurrency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatCurrency.format(value);
  }

  String formatBusDetailTime(String time) {
    // Parse the ISO 8601 string
    DateTime dateTime = DateTime.parse(time);

    // Format the date and time
    String formattedDate = DateFormat('d-MMM-yyyy').format(dateTime);
    String formattedTime = DateFormat('HH:mm').format(dateTime); // e.g., 22:25

    // Return formatted date and time
    return '$formattedDate\n$formattedTime'; // Add a newline character
  }

  void _showConfirmationDialog(BuildContext context, int price) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text('Konfirmasi', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return ListBody(
                children: [
                  Text('Berangkat dari:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(departureRoute!),
                  SizedBox(height: 8),

                  Text('Tujuan:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(selectedDestination!),
                  SizedBox(height: 8),
                  Visibility(
                      visible: busDetail!.ticket
                              .firstWhere((t) => t.id == ticketId)
                              .tipeIsi ==
                          'barang',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Titik Kumpul Barang:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(selectedTikum[0]),
                          SizedBox(height: 8),
                        ],
                      )),
                  Text(
                      busDetail!.ticket
                                  .firstWhere((t) => t.id == ticketId)
                                  .tipeIsi ==
                              'barang'
                          ? 'Jumlah Barang: '
                          : 'Kursi yang dipilih: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(busDetail!.ticket
                              .firstWhere((t) => t.id == ticketId)
                              .tipeIsi ==
                          'barang'
                      ? quantity.toString()
                      : selectedSeats.join(', ')),
                  SizedBox(height: 8),

                  // Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Harga Tiket:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        formatRupiah(totalPrice),
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),

                  // Admin Fee
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Biaya Layanan:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        formatRupiah(1000),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kode Unik:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        formatRupiah(int.parse(price
                            .toString()
                            .substring(price.toString().length - 3))),
                      ),
                    ],
                  ),

                  Divider(height: 16),

                  // Total Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Transfer:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        formatRupiah(price + 1000),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  busDetail!.ticket
                              .firstWhere((t) => t.id == ticketId)
                              .tipeIsi ==
                          'barang'
                      ? Container()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton.icon(
                              icon: Icon(Icons.person,
                                  color: Colors.blue), // Add icon
                              label: Text('Pesan Sendiri',
                                  style: TextStyle(color: Colors.blue)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.blue),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {
                                setState(() {
                                  seatName[0] = userName!;
                                  seatNameControllers[0].text = userName!;
                                  passengerGenders[0] = userGender!;
                                });
                              },
                            ),
                            Text('Masukkan nama penumpang:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                  SizedBox(height: 8),

                  ...List.generate(
                    selectedSeats.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          // Expanded TextField for Passenger Name
                          Expanded(
                            flex: 3,
                            child: TextField(
                              controller: seatNameControllers[index],
                              onChanged: (value) {
                                setState(() {
                                  seatName[index] = value;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Nama Penumpang ${index + 1}',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),

                          // Gender Radios in Row with individual Radio buttons
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                      child: Radio<String>(
                                        value: 'laki',
                                        groupValue: passengerGenders[index],
                                        onChanged: (value) {
                                          setState(() {
                                            passengerGenders[index] = value!;
                                          });
                                        },
                                      ),
                                    ),
                                    const Text('L'),
                                  ],
                                ),
                                // Gender 'P' Radio
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                      child: Radio<String>(
                                        value: 'perempuan',
                                        groupValue: passengerGenders[index],
                                        onChanged: (value) {
                                          setState(() {
                                            passengerGenders[index] = value!;
                                          });
                                        },
                                      ),
                                    ),
                                    const Text('P'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  busDetail!.ticket
                              .firstWhere((t) => t.id == ticketId)
                              .tipeIsi ==
                          'barang'
                      ? Container()
                      : Text('Masukan Titik Kumpul Setiap Penumpang:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),

                  // Pickup Points
                  ...List.generate(
                      selectedSeats.length,
                      (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText:
                                    'Titik Kumpul Penumpang ${index + 1}',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                              ),
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors.grey.shade600),
                              value: selectedTikum[index].isEmpty
                                  ? null
                                  : selectedTikum[index],
                              items: busDetail!.tikum.map((tikum) {
                                return DropdownMenuItem<String>(
                                  value: tikum,
                                  child: Text(tikum),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedTikum[index] = value!;
                                });
                              },
                            ),
                          )),
                ],
              );
            }),
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Confirm', style: TextStyle(color: Colors.green)),
              onPressed: () async {
                if (seatName.contains('') || selectedTikum.contains('')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Isi semua nama dan titik kumpul.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                try {
                  final bookingResult = await ticketService().bookingTicket(
                      context,
                      userIdAccount!,
                      ticketId!,
                      price + 1000,
                      busDetail!.ticket
                                  .firstWhere((t) => t.id == ticketId)
                                  .tipeIsi ==
                              'barang'
                          ? [0]
                          : selectedSeats,
                      busDetail!.ticket
                                  .firstWhere((t) => t.id == ticketId)
                                  .tipeIsi ==
                              'barang'
                          ? quantity
                          : 0,
                      departureRoute!,
                      selectedDestination!,
                      seatName.isNotEmpty ? seatName : [userName!],
                      selectedTikum.isNotEmpty ? selectedTikum : [""],
                      passengerGenders.isNotEmpty
                          ? passengerGenders
                          : [userGender!]);

                  if (!context.mounted) return;

                  Navigator.pop(context);
                  if (bookingResult == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          price: price + 1000,
                          date: currentDate,
                        ),
                      ),
                    );
                  } else {
                    setState(() {
                      price = 0;
                      totalPrice = 0;
                      seatName = [];
                      selectedSeats = [];
                      selectedTikum = [];
                      passengerGenders = [];
                    });
                    getData();
                  }
                } catch (e) {
                  print('Error during booking: $e');
                }
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
                              busDetail!.ticket
                                          .firstWhere((t) => t.id == ticketId)
                                          .tipeIsi ==
                                      'barang'
                                  ? 'Total Barang: ${busDetail!.storage}'
                                  : 'Total Kursi: ${busDetail!.seat}',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            SizedBox(width: 20),
                            Text(
                              busDetail!.ticket
                                          .firstWhere((t) => t.id == ticketId)
                                          .tipeIsi ==
                                      'barang'
                                  ? 'Slot Barang Tersisa: ${busDetail!.storage - busDetail!.ticket.firstWhere((t) => t.id == ticketId).jumlahBarang}'
                                  : 'Kursi Tersisa: ${busDetail!.seat - busDetail!.ticket.firstWhere((t) => t.id == ticketId).seat.length}',
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
                                  selectedSeats = [];
                                  totalPrice = 0;
                                  quantity = 0;
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
                      child: busDetail!.ticket
                                  .firstWhere((t) => t.id == ticketId)
                                  .tipeIsi ==
                              'barang'
                          ? buildInputJumlahBarang()
                          : buildSeatLayout(),
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
                    onPressed: selectedSeats.isNotEmpty || quantity > 0
                        ? () async {
                            busDetail!.ticket
                                            .firstWhere((t) => t.id == ticketId)
                                            .tipeIsi ==
                                        'barang' &&
                                    selectedTikum.isEmpty
                                ? selectedTikum.add(busDetail!.tikum[0])
                                : null;
                            var x = await ticketService()
                                .getUniquePrice(context, totalPrice);
                            _showConfirmationDialog(
                                context, Utilities.parseInt(x));
                          }
                        : null,
                    child: Text('Pesan Sekarang',
                        style: TextStyle(fontSize: 18.0)),
                  ),
                ),
              ],
            ),
    );
  }
}
