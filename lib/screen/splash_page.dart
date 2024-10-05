import 'package:flutter/material.dart';
import 'package:redbus_project/screen/introduction_page.dart';
import 'package:redbus_project/screen/login_page.dart';
import 'package:redbus_project/screen/main_page.dart';
import 'package:redbus_project/screen/unregister_page.dart';
import 'package:redbus_project/services/auth_service.dart';
import 'package:redbus_project/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Import your IntroductionPage here

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    checkFirstTime();
  }

  Future<void> checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      // Navigate to Introduction Page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => IntroductionPage()),
      );
      prefs.setBool('isFirstTime', false);
    } else {
      // Navigate to Home Page
      getMe();
    }
  }

  getMe() async {
    isLoading = true;
    var x = await AuthService().getMe(context);
    isLoading = false;
    setState(() {});
    if (x.isActive == 0) {
      // Navigate to UnregisterPage if is_active is 0
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UnregisterPage()),
      );
    } else if (x.isActive == 1) {
      // Navigate to HomePage if is_active is 1
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading ? CircularProgressIndicator() : Container(),
      ),
    );
  }
}
