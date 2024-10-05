import 'package:flutter/material.dart';
import 'package:redbus_project/screen/login_page.dart';
import 'package:redbus_project/screen/main_page.dart';
import 'package:redbus_project/services/auth_service.dart';
import 'package:redbus_project/utils/theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isVisible = true;
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
                // Icon(Icons.discount),
                // SizedBox(height: 10),
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
                  'Buat Akun Anda',
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
                            await AuthService().register(context,
                                emailController.text, passwordController.text);

                            setState(() {
                              isLoading = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          label: Text(
                            'REGISTER',
                            style: TextStyle(color: Colors.white),
                          ),
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
          // Spacer(),
          Text(
            'Dengan melakukan pemesanan, saya sudah setuju dengan semua Syarat dan Ketentuan serta Ketentuan Privasi',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text("Sudah Punya Akun? Login"),
            style: TextButton.styleFrom(
              // primary: Colors.blue,
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
