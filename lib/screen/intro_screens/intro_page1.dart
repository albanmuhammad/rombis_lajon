import 'package:flutter/material.dart';
import 'package:redbus_project/screen/login_page.dart';
import 'package:redbus_project/screen/register_page.dart';
import 'package:redbus_project/utils/theme.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(
            255, 255, 139, 139), // Background color matching the theme
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 90.0, bottom: 20.0),
              child: Text(
                "Selamat Datang di \n Rombis Lajon",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text for contrast
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: 500,
                  height: 500,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Image.asset(
                      'assets/illustration.png', // Path to your local image
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: SizedBox(
                    width: double
                        .infinity, // Takes up the full width of the parent
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            primaryColor, // Button background color
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        elevation: 5, // Light shadow to enhance the UI
                      ),
                      child: const Text(
                        "MASUK",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Space between the two buttons
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: SizedBox(
                    width: double
                        .infinity, // Takes up the full width of the parent
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.white, // Button background color
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          // side: BorderSide(color: primaryColor, width: 2),
                        ),
                        elevation: 5, // Light shadow to enhance the UI
                      ),
                      child: Text(
                        "DAFTAR",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 70,
            )
          ],
        ),
      ),
    );
  }
}
