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
  bool isForgotPassword = false;

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
                            'LOGIN',
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
                                                            passwordController,
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
                                                                passwordController
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
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                content:
                                                                    SelectableText(
                                                                        "Reset password sukses"),
                                                              ));
                                                            } else {
                                                              Navigator.pop(
                                                                  context);
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                content:
                                                                    SelectableText(
                                                                        "Reset password gagal"),
                                                              ));
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
                      'Lanjut dengan Google',
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
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
