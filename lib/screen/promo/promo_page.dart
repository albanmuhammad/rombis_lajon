import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:redbus_project/utils/theme.dart';
import 'package:redbus_project/widgets/other_promo_card.dart';
import 'package:redbus_project/widgets/promo_card_2.dart';
import 'package:redbus_project/widgets/promo_card_3.dart';

// import '../../widgets/marquee.dart';

class PromoPage extends StatefulWidget {
  const PromoPage({super.key});

  @override
  State<PromoPage> createState() => _PromoPageState();
}

class _PromoPageState extends State<PromoPage> {
  Widget routeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Promo Section
        ClipPath(
          clipper: CurvedBackgroundClipper(),
          child: Container(
            color: primaryColor,
            width: MediaQuery.of(context).size.width,
            height: 200, // Adjust the height as needed
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'PROMO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Lebih murah dari Loket',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '20+ Operator Bus',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Rute Bus Teratas Section
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Rute bus teratas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 160, // Adjust the height as needed
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      height: 160, // Match the parent's height
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Center vertically
                        children: [
                          PromoCard2(
                              discount: '20% off',
                              route: 'Surabaya -> Jakarta',
                              imagePath: 'assets/bus1.jpg'),
                        ],
                      ),
                    ),
                    Container(
                      height: 160,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PromoCard2(
                              discount: '20% off',
                              route: 'Jakarta -> Surabaya',
                              imagePath: 'assets/bus2.jpg'),
                        ],
                      ),
                    ),
                    Container(
                      height: 160,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PromoCard2(
                              discount: '15% off',
                              route: 'Bandung -> Yogyakarta',
                              imagePath: 'assets/bus3.jpg'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Container(
          height: 8, // Same height as the SizedBox
          width: double.infinity, // Full width
          color: Colors.white, // Blue background color
        ),
        // Rute Shuttle Teratas Section
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Rute shuttle teratas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 160, // Adjust the height as needed
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      height: 160, // Match the parent's height
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Center vertically
                        children: [
                          PromoCard2(
                              discount: '20% off',
                              route: 'Surabaya -> Jakarta',
                              imagePath: 'assets/bus1.jpg'),
                        ],
                      ),
                    ),
                    Container(
                      height: 160,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PromoCard2(
                              discount: '20% off',
                              route: 'Jakarta -> Surabaya',
                              imagePath: 'assets/bus2.jpg'),
                        ],
                      ),
                    ),
                    Container(
                      height: 160,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PromoCard2(
                              discount: '15% off',
                              route: 'Bandung -> Yogyakarta',
                              imagePath: 'assets/bus3.jpg'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Container(
          height: 8, // Same height as the SizedBox
          width: double.infinity, // Full width
          color: Colors.white, // Blue background color
        ),
      ],
    );
  }

  Widget flashSaleSection() {
    return Container(
      color: secondaryColor2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 16,
              ),
              const Icon(
                Icons.flash_on,
                color: Colors.yellow,
                size: 40,
              ), // Fixed Thunderbolt Icon
              // SizedBox(width: 16.0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Marquee(
                    // autoRepeat: true,
                    // backwardAnimation: Curves.easeInBack,
                    pauseDuration: Duration.zero,
                    animationDuration: Duration(milliseconds: 10000),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Penawaran Kilat ',
                            style: TextStyle(
                                fontWeight: bold,
                                fontSize: 24,
                                color: primaryColor)),
                        Text('Penawaran Kilat ',
                            style: TextStyle(
                                fontWeight: bold,
                                fontSize: 24,
                                color: secondaryColor1)),
                        Text('Penawaran Kilat ',
                            style: TextStyle(
                                fontWeight: bold,
                                fontSize: 24,
                                color: primaryColor)),
                        Text('Penawaran Kilat ',
                            style: TextStyle(
                                fontWeight: bold,
                                fontSize: 24,
                                color: secondaryColor1)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 160, // Adjust the height as needed
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  height: 160, // Match the parent's height
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center vertically
                    children: [
                      PromoCard3(
                          discount: '20% off',
                          route: 'Surabaya -> Jakarta',
                          imagePath: 'assets/bus1.jpg'),
                    ],
                  ),
                ),
                Container(
                  height: 160,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PromoCard3(
                          discount: '20% off',
                          route: 'Jakarta -> Surabaya',
                          imagePath: 'assets/bus2.jpg'),
                    ],
                  ),
                ),
                Container(
                  height: 160,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PromoCard3(
                          discount: '15% off',
                          route: 'Bandung -> Yogyakarta',
                          imagePath: 'assets/bus3.jpg'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 8, // Same height as the SizedBox
            width: double.infinity, // Full width
            color: Colors.white, // Blue background color
          ),
        ],
      ),
    );
  }

  Widget otherPromoSection() {
    return Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Promo Lain Untuk Anda!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    OtherPromoCard(secondaryColor2: secondaryColor2),
                    OtherPromoCard(secondaryColor2: secondaryColor2),
                    OtherPromoCard(secondaryColor2: secondaryColor2)
                  ],
                )),
          ],
        ));
  }

  Widget OwnedPromo() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
          // color: secondaryColor3,
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Anda Memiliki',
            style: TextStyle(
                color: secondaryColor3,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          Text(
            '50+ promo, 20+ operator bus di 40+ rute!!!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        routeSection(),
        flashSaleSection(),
        otherPromoSection(),
        OwnedPromo()
      ],
    );
  }
}

class CurvedBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Move to the top-left corner
    path.lineTo(0, size.height - 50);

    // Create a single curve from left to right
    var controlPoint = Offset(size.width / 2, size.height + 50);
    var endPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    // Line to the top-right corner
    path.lineTo(size.width, 0);

    // Close the path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
