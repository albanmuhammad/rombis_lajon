import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:redbus_project/utils/theme.dart';

class PromoCard3 extends StatelessWidget {
  final String discount;
  final String route;
  final String imagePath;

  const PromoCard3({
    Key? key,
    required this.discount,
    required this.route,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Blue background layer
        Container(
          width: 140,
          height: 140,
          margin: EdgeInsets.only(left: 16, bottom: 8),
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: secondaryColor1,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Penawaran Terbaaa',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white),
              )),
        ),

        // Main white card
        Positioned(
          top: -10,
          child: Container(
            width: 140,
            height: 120,
            margin: EdgeInsets.only(left: 16, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Diskon",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    discount,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    route,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
