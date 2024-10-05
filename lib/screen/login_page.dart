import 'package:flutter/material.dart';
import 'package:redbus_project/model/auth/user.dart';
import 'package:redbus_project/screen/main_page.dart';
import 'package:redbus_project/screen/register_page.dart';
import 'package:redbus_project/screen/unregister_page.dart';
import 'package:redbus_project/services/auth_service.dart';
import 'package:redbus_project/utils/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Top promotional section
          Container(
            width: double.infinity,
            color: primaryColor,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Baru bergabung di Rombis Lajon',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Form section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Verifikasi data Anda',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Masukan Usename/Email',
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: isVisible,
                  controller: passwordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Masukan Password',
                      suffixIcon: GestureDetector(
                        child: Icon(isVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onTap: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                      )),
                ),
                SizedBox(height: 20),
                // OTP Button
                isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });

                            var x = await AuthService().login(context,
                                emailController.text, passwordController.text);

                            setState(() {
                              isLoading = false;
                            });

                            // Check if login is successful
                            if (x == false) {
                              // Notify user of failed login using SnackBar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Login failed. Please try again.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              // Check if the user is active or not
                              if (x.isActive == 0) {
                                // Navigate to UnregisterPage if is_active is 0
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UnregisterPage()),
                                );
                              } else if (x.isActive == 1) {
                                // Navigate to HomePage if is_active is 1
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainPage()),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          label: Text(
                            'LOGIN',
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: Icon(Icons.login),
                        ),
                      ),
                SizedBox(height: 10),
                // OR Text
                Row(
                  children: <Widget>[
                    Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("Atau"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 10),
                // Google Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.login, color: Colors.black),
                    label: Text(
                      'Continue with Google',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Section
          Text(
            'Dengan melakukan pemesanan, saya sudah setuju dengan semua Syarat dan Ketentuan serta Ketentuan Privasi',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterPage()));
            },
            child: Text("Belum Punya Akun? Daftar"),
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
