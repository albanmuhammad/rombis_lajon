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
    String formattedCurrentDate = DateFormat('yyyy-MM-dd').format(currentDate);
    date = (widget.date != null && widget.date!.isNotEmpty)
        ? widget.date!.split(' ')[0] // This will give you "2024-19-10"
        : formattedCurrentDate;

    // // Simulasi delay untuk loading
    // var x = await ticketService().getUniquePrice(context, price);
    // priceUnique = Utilities.parseInt(x);
    setState(() {
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
            Navigator.push(
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
                  Text(
                    'Rp ${price.toString()}',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Tanggal Pembelian:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    date,
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
                    'Bank: BCA\nNo Rekening: 1234567890\nAtas Nama: Ahmad Lancelot',
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
