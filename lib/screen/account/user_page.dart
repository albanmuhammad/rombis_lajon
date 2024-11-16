import 'package:flutter/material.dart';
import 'package:redbus_project/model/auth/user.dart';
import 'package:redbus_project/services/auth_service.dart';
// import 'package:flutter_svg/flutter_svg.dart'; // Import Flutter SVG package

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  void initState() {
    getData();
    super.initState();
  }

  bool _isEditing = false;
  late User user;
  String userName = "";
  String gender = "";
  String userId = "";
  String phoneNumber = "";
  String fullName = "";
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  bool showPasswordField = false;
  bool passwordVisible = false;

  getData() async {
    setState(() {
      isLoading = true;
    });
    var x = await AuthService().getMe(context);
    user = x;
    setState(() {
      isLoading = false;
      userName = user.userName;
      userId = user.id;
      userNameController.text = user.userName;
      fullName = user.fullName;
      phoneNumber = user.phoneNumber;
      gender = user.gender;
    });
  }

  Future<void> resetPassword() async {
    setState(() {
      isLoading = true;
    });

    // Make the reset password request here
    await AuthService()
        .resetPassword(context, userId, newPasswordController.text);

    setState(() {
      isLoading = false;
      showPasswordField = false;
      newPasswordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Profil Akun'),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.edit), // Replace with your pencil icon path
          //   onPressed: () {
          //     setState(() {
          //       _isEditing = !_isEditing;
          //     });
          //   },
          // ),
          IconButton(
            icon: Icon(Icons.logout), // Replace with your pencil icon path
            onPressed: () {
              AuthService().logout(context);
            },
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                padding: EdgeInsets.all(16),
                // color: Colors.red,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Picture
                    CircleAvatar(
                      radius: 50,
                      child: Icon(
                        Icons.account_circle_rounded,
                        size: 60,
                      ),
                      // Replace with your profile picture path
                    ),
                    const SizedBox(height: 16),
                    // Username
                    Text(
                      userName,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      gender == "laki" ? "Laki-Laki" : "Perempuan",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '+${phoneNumber}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      fullName,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    if (showPasswordField) ...[
                      TextField(
                        controller: newPasswordController,
                        obscureText: !passwordVisible,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                passwordVisible =
                                    !passwordVisible; // Toggle password visibility
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    ElevatedButton(
                      onPressed: () async {
                        if (showPasswordField) {
                          await resetPassword();
                        } else {
                          setState(() {
                            showPasswordField = true;
                          });
                        }
                      },
                      child: Text(showPasswordField
                          ? 'Save Password'
                          : 'Reset Password'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
