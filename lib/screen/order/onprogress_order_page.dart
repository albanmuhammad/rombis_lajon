import 'package:flutter/material.dart';
import 'package:redbus_project/widgets/onprocess_order_card.dart';

class MyTicketPage extends StatefulWidget {
  const MyTicketPage({super.key});

  @override
  State<MyTicketPage> createState() => _MyTicketPageState();
}

class _MyTicketPageState extends State<MyTicketPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.817,
      padding: EdgeInsets.all(16),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          OnprocessOrderCard(),
          OnprocessOrderCard(),
          OnprocessOrderCard(),
          OnprocessOrderCard(),
        ],
      ),
    );
  }
}
