import 'package:flutter/material.dart';
import 'package:redbus_project/utils/theme.dart';

class PromoCard extends StatelessWidget {
  final String discount;
  final String route;
  final IconData icon;

  PromoCard({
    required this.discount,
    required this.route,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                discount,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Icon(icon, size: 40),
              SizedBox(height: 10),
              Text(route, style: TextStyle(color: secondaryColor3)),
            ],
          ),
        ),
      ),
    );
  }
}
