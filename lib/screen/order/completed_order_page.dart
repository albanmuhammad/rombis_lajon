import 'package:flutter/material.dart';
import 'package:redbus_project/widgets/completed_order_card.dart';

class CompletedTicketPage extends StatefulWidget {
  const CompletedTicketPage({super.key});

  @override
  State<CompletedTicketPage> createState() => _CompletedTicketPageState();
}

class _CompletedTicketPageState extends State<CompletedTicketPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.817,
      padding: EdgeInsets.all(16),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          CompletedOrderCard(),
          CompletedOrderCard(),
          CompletedOrderCard(),
          CompletedOrderCard(),
        ],
      ),
    );
  }
}
