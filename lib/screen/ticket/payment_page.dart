import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redbus_project/screen/home/home_page.dart';
import 'package:redbus_project/screen/main_page.dart';
import 'package:redbus_project/services/ticket_service.dart';
import 'package:redbus_project/utils/utilities.dart';

class PaymentPage extends StatefulWidget {
  final int? price;
  final String? date;

  PaymentPage({this.price, this.date});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isLoading = false;
  int price = 0;
  int priceUnique = 0;
  String dateText = "";
  String date = "";

  @override
  void initState() {
    initData();
    super.initState();
  }

  initData() async {
    setState(() {
      isLoading = true;
    });
    price = widget.price!;
    DateTime currentDate = DateTime.now().toUtc();
    String formattedCurrentDate = DateFormat('d-MMMM-yyyy').format(currentDate);
    // Check if widget.date is not null and not empty
    if (widget.date != null && widget.date!.isNotEmpty) {
      // Split the date string and parse it into a DateTime object
      DateTime parsedDate = DateTime.parse(widget.date!.split(' ')[0]);
      // Format the parsed date
      dateText = DateFormat('d MMMM yyyy').format(parsedDate);
      date = widget.date!.split(' ')[0];
    } else {
      dateText = formattedCurrentDate;
      date = DateFormat('yyyy-MM-DD').format(currentDate);
    }

    // // Simulasi delay untuk loading
    // var x = await ticketService().getUniquePrice(context, price);
    // priceUnique = Utilities.parseInt(x);
    setState(() {
      isLoading = false;
    });
  }

  Widget formatRupiahWithBold(int value) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    String formattedText = formatCurrency.format(value);

    // Separate the last 3 digits for bold styling
    String mainText = formattedText.substring(0, formattedText.length - 3);
    String boldText = formattedText.substring(formattedText.length - 3);

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
              text: mainText,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
          TextSpan(
              text: boldText,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.orange)),
        ],
      ),
      style: TextStyle(fontSize: 16, color: Colors.black54),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_sharp),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MainPage(
                          index: 1,
                        )));
          },
        ),
        title: Text('Menunggu Pembayaran'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detail Pembayaran',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Total Harga:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  formatRupiahWithBold(price),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                          fontSize: 16, color: Colors.black), // Default style
                      children: [
                        TextSpan(
                            text:
                                'Pastikan Jumlah Transfer Sudah \nBenar Hingga '),
                        TextSpan(
                          text: '3 Digit',
                          style: TextStyle(
                            backgroundColor:
                                Colors.orange, // Background color for "3 Digit"
                          ),
                        ),
                        TextSpan(text: ' Terakhir!'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Tanggal Pembelian:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    dateText,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Pastikan Pembayaran Tidak Lebih dari 24 Jam Kedepan',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 20),
                  Text(
                    'Silahkan transfer ke rekening berikut:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Bank Central Asia',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'No Rekening: 1220085682\nAtas Nama: R. Bambang Agus',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          final confirmationResult = await ticketService()
                              .confirmationPayment(context, price, date);

                          if (!context.mounted)
                            return; // Check if context is still valid

                          if (confirmationResult == true) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainPage(
                                          index: 1,
                                          tabIndex: 1,
                                        )));
                          }
                        } catch (e) {
                          // Handle any errors
                          print('Error during payment confirmation: $e');
                        }
                      },
                      child: Text('Saya Sudah Transfer'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
