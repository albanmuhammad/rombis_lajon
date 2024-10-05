import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';

class PromoCard2 extends StatelessWidget {
  final String discount;
  final String route;
  final String imagePath;

  const PromoCard2({
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
          width: 220,
          height: 140,
          margin: EdgeInsets.only(left: 16, bottom: 8),
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Marquee(
              autoRepeat: true,
              // backwardAnimation: Curves.easeInBack,
              pauseDuration: Duration.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '15% off ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Icon(Icons.travel_explore),
                  Text(
                    '15% off ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Icon(Icons.travel_explore),
                  Text(
                    '15% off ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Icon(Icons.travel_explore),
                  Text(
                    '15% off ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Icon(Icons.travel_explore),
                  Text(
                    '15% off ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Icon(Icons.travel_explore),
                  Text(
                    '15% off ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Icon(Icons.travel_explore),
                  // ... remaining repetitive text and icons
                ],
              ),
            ),
          ),
        ),

        // Main white card
        Positioned(
          top: -10,
          child: Container(
            width: 220,
            height: 110,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                      SizedBox(height: 4),
                      Text(
                        route,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Use a cached network image or appropriate image widget based on imagePath
                Icon(
                  Icons.bus_alert,
                  size: 40,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
