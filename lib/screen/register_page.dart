import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
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
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String phoneNumber = "";
  bool isLoading = false;
  bool isVisible = true;
  String? gender;
  String? errorMessage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          'Baru bergabung di Rombis Lajon',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            // Top promotional section

            // Form section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 24),
                  Text(
                    'Buat Akun Anda',
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Declare a variable to store the error message

                  TextFormField(
                    obscureText: isVisible,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Masukan Password',
                      suffixIcon: GestureDetector(
                        child: Icon(
                          isVisible ? Icons.visibility_off : Icons.visibility,
                        ),
                        onTap: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                      ),
                      // Display error message if available
                      errorText: errorMessage,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password tidak boleh kosong';
                      } else if (value.length < 8) {
                        return 'Password minimal harus 8 karakter';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        // Validate password length
                        if (value.length < 8) {
                          errorMessage = 'Password minimal harus 8 karakter';
                        } else {
                          errorMessage = null; // Reset error if valid
                        }
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  IntlPhoneField(
                    decoration: InputDecoration(
                      labelText: 'Nomor Telepon',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    initialCountryCode: 'ID', // Default country (Indonesia)
                    onChanged: (phone) {
                      String formattedNumber =
                          phone.completeNumber.replaceFirst('+', '');
                      print('Formatted Phone Number: $formattedNumber');
                      phoneNumber = formattedNumber;
                    },
                    validator: (value) {
                      if (value == null || value.number.isEmpty) {
                        return 'Nomor telepon tidak boleh kosong';
                      }
                      if (value.number.length < 10) {
                        return 'Nomor telepon harus minimal 10 digit';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Masukan Nama Lengkap',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama Lengkap tidak boleh kosong';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 24),
                  // OTP Button
                  // Gender selection
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih Jenis Kelamin',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: RadioListTile<String>(
                              contentPadding: EdgeInsets.zero,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Laki-laki"),
                                ],
                              ),
                              value: "laki",
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value;
                                });
                              },
                            ),
                          ),
                          Flexible(
                            child: RadioListTile<String>(
                              contentPadding: EdgeInsets.zero,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Perempuan"),
                                ],
                              ),
                              value: "perempuan",
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  gender != null) {
                                setState(() {
                                  isLoading = true;
                                });
                                await AuthService().register(
                                    context,
                                    emailController.text,
                                    passwordController.text,
                                    gender!,
                                    phoneNumber,
                                    fullNameController.text);

                                setState(() {
                                  isLoading = false;
                                });
                              } else {
                                // Show an alert for missing gender if it's null
                                if (gender == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Silakan pilih jenis kelamin'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                            label: Text(
                              'DAFTAR',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                  SizedBox(height: 10),
                ],
              ),
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
      ),
    );
  }
}
