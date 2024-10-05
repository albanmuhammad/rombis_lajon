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
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  getData() async {
    var x = await AuthService().getMe(context);
    user = x;
    setState(() {
      userName = user.userName;
      userNameController.text = user.userName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit), // Replace with your pencil icon path
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.logout), // Replace with your pencil icon path
            onPressed: () {
              AuthService().logout(context);
            },
          )
        ],
      ),
      body: Center(
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
              // Editable Fields
              if (_isEditing)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: userNameController,
                      decoration: InputDecoration(labelText: 'Username'),
                      onChanged: (value) {
                        // Update username
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Save changes
                        setState(() {
                          _isEditing = false;
                        });
                      },
                      child: const Text('Save Changes'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
