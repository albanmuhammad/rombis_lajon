import 'package:flutter/material.dart';
import 'package:redbus_project/widgets/cancelled_order_card.dart';

class CancelledTicketPage extends StatefulWidget {
  const CancelledTicketPage({super.key});

  @override
  State<CancelledTicketPage> createState() => _CancelledTicketPageState();
}

class _CancelledTicketPageState extends State<CancelledTicketPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.817,
      padding: EdgeInsets.all(16),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          CancelledOrderCard(),
          CancelledOrderCard(),
          CancelledOrderCard(),
          CancelledOrderCard(),
        ],
      ),
    );
  }
}
