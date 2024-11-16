import 'package:flutter/material.dart';
import 'package:redbus_project/screen/login_page.dart';
import 'package:redbus_project/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class UnregisterPage extends StatefulWidget {
  const UnregisterPage({Key? key}) : super(key: key);

  @override
  State<UnregisterPage> createState() => _UnregisterPageState();
}

class _UnregisterPageState extends State<UnregisterPage> {
  Future<void> openWhatsApp() async {
    final Uri url = Uri.parse('https://wa.me/628164231047');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Akun Belum Terverifikasi',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon or Image
            Icon(
              Icons.lock_outline,
              size: 100,
              color: primaryColor,
            ),
            SizedBox(height: 20),

            // Title Text
            Text(
              'Akun Anda Belum Terverifikasi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),

            // Description Text
            Text(
              'Mohon tunggu hingga akun Anda diverifikasi oleh admin. Anda akan diberi tahu jika akun sudah aktif.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),

            // Refresh Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'Coba Lagi',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Contact Admin Button (optional)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  openWhatsApp();
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  side: BorderSide(color: primaryColor),
                ),
                child: Text(
                  'Hubungi Admin',
                  style: TextStyle(fontSize: 16, color: primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
