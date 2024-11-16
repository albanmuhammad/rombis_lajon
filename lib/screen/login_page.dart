import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  TextEditingController resetPasswordController = TextEditingController();
  bool isVisible = true;
  bool isLoading = false;
  bool isForgotPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Selamat datang di Rombis Lajon',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Form section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 24),
                Text(
                  'Masukan Data Anda',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 24),
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
                              setState(() {
                                isForgotPassword = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Login failed. Please try again.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              // Check if the user is active or not
                              if (x.isActive == false) {
                                // Navigate to UnregisterPage if is_active is 0
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UnregisterPage()),
                                );
                              } else if (x.isActive == true) {
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
                            'MASUK',
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: Icon(Icons.login),
                        ),
                      ),
                SizedBox(height: 10),
                // OR Text
                Visibility(
                  visible: isForgotPassword,
                  child: TextButton(
                    onPressed: () {
                      // Show a modal bottom sheet when "Lupa Password" is clicked
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled:
                            true, // Allows modal to expand for keyboard
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (BuildContext context) {
                          TextEditingController usernameController =
                              TextEditingController();
                          return Padding(
                            padding: MediaQuery.of(context)
                                .viewInsets, // Adjust for keyboard
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize
                                    .min, // Makes modal height adjustable
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reset Password',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Masukkan username/email Anda untuk mereset password.',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    controller: usernameController,
                                    decoration: InputDecoration(
                                      labelText: 'Username/Email',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        // Implement your forgot password logic here
                                        String username =
                                            usernameController.text;
                                        // Close the modal after processing
                                        var chekUsername = await AuthService()
                                            .checkUsername(context, username);
                                        if (chekUsername != null) {
                                          Navigator.pop(context);
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled:
                                                true, // Allows modal to expand for keyboard
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(20)),
                                            ),
                                            builder: (BuildContext context) {
                                              TextEditingController
                                                  usernameController =
                                                  TextEditingController();
                                              return Padding(
                                                padding: MediaQuery.of(context)
                                                    .viewInsets, // Adjust for keyboard
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize
                                                        .min, // Makes modal height adjustable
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Reset Password',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Text(
                                                        'Masukkan password baru anda',
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      SizedBox(height: 20),
                                                      TextFormField(
                                                        controller:
                                                            resetPasswordController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: 'Password',
                                                          border:
                                                              OutlineInputBorder(),
                                                        ),
                                                      ),
                                                      SizedBox(height: 20),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: ElevatedButton(
                                                          onPressed: () async {
                                                            // Implement your forgot password logic here
                                                            String password =
                                                                resetPasswordController
                                                                    .text;
                                                            // Close the modal after processing
                                                            var x = await AuthService()
                                                                .resetPassword(
                                                                    context,
                                                                    chekUsername,
                                                                    password);
                                                            if (x == true) {
                                                              Navigator.pop(
                                                                  context);
                                                            } else {
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          },
                                                          child: Text('Kirim'),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                primaryColor,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        15),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: SelectableText(
                                                "Username tidak ditemukan."),
                                          ));
                                        }
                                      },
                                      child: Text('Kirim'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Text("Lupa Password?"),
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
