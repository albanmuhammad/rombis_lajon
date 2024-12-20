import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:redbus_project/model/auth/user.dart';
import 'package:redbus_project/screen/introduction_page.dart';
import 'package:redbus_project/screen/login_page.dart';
import 'package:redbus_project/screen/main_page.dart';
import 'package:redbus_project/services/http_request.dart';
import 'package:redbus_project/utils/constant.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<SharedPreferences> get sp async {
    return await SharedPreferences.getInstance();
  }

  Future<String> getToken() async {
    return (await sp).getString(Constant.token) ?? "";
  }

  Future<String> getUserId() async {
    return (await sp).getString(Constant.userId) ?? "";
  }

  Future<String> getUserName() async {
    return (await sp).getString("userName") ?? "";
  }

  Future<String> getUserGender() async {
    return (await sp).getString("gender") ?? "";
  }

  Future<void> setToken(token) async {
    SharedPreferences spp = await SharedPreferences.getInstance();
    spp.setString(Constant.token, token);
  }

  Future<void> setUserId(userId) async {
    SharedPreferences spp = await SharedPreferences.getInstance();
    spp.setString(Constant.userId, userId);
  }

  Future<void> setUserName(userName) async {
    SharedPreferences spp = await SharedPreferences.getInstance();
    spp.setString("userName", userName);
  }

  Future<void> setUserGender(userGender) async {
    SharedPreferences spp = await SharedPreferences.getInstance();
    spp.setString("gender", userGender);
  }

  Future<void> clearPrefs() async {
    final prefs = await sp; // Assuming 'sp' is your SharedPreferences instance
    final keys = prefs.getKeys(); // Get all keys in SharedPreferences

    for (String key in keys) {
      if (key != 'isFirstTime') {
        await prefs.remove(key); // Remove all keys except 'isFirstTime'
      }
    }
  }

  getIdFromResponse(String responseBody) {
    // Parse the JSON response
    final Map<String, dynamic> parsedJson = json.decode(responseBody);

    // Access the 'id' inside the 'authSession'
    final String id = parsedJson['authSession'];

    print('ID: $id');
    return id;
  }

  getUserIdFromResponse(String responseBody) {
    // Parse the JSON response
    final Map<String, dynamic> parsedJson = json.decode(responseBody);

    // Access the 'id' inside the 'authSession'
    final String userId = parsedJson['user'];

    print('ID: $userId');
    return userId;
  }

  login(BuildContext context, String username, String password) async {
    final response = await HttpRequest(context).post(
        url: Constant.loginApiUrl,
        useToken: false,
        body: jsonEncode({
          Constant.username: username,
          Constant.password: password,
          "rememberMe": true
        }));

    if (response.statusCode == 200) {
      // final loginResponse = LoginResponse.fromJson(json.decode(response.body));

      AuthService().setToken(getIdFromResponse(response.body));
      AuthService().setUserId(getUserIdFromResponse(response.body));
      print('sukses');
      return await getMe(context);
    } else {
      print('Login gagal');
      return false;
    }
  }

  register(BuildContext context, String username, String password,
      String gender, String phoneNumber, String fullName) async {
    final response = await HttpRequest(context).post(
        url: Constant.registerApiUrl,
        useToken: false,
        body: jsonEncode({
          Constant.username: username,
          Constant.password: password,
          "gender": gender,
          "noTelepon": phoneNumber,
          "namaLengkap": fullName
        }));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // final loginResponse = LoginResponse.fromJson(json.decode(response.body));

      // AuthService().setUser(context, loginResponse.data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: SelectableText(
            "Register Akun Sukses, silahkan tunggu diverifikasi admin"),
      ));
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      final decodedResponse = json.decode(response.body);
      final message = decodedResponse['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: SelectableText(message),
      ));
    }
  }

  checkUsername(BuildContext context, String username) async {
    final response = await HttpRequest(context).get(
      url: Constant.checkUsername + "?username=${username}",
      useToken: false,
    );
    if (response.statusCode == 200) {
      // Parse the response body
      Map<String, dynamic> responseBody = jsonDecode(response.body);

      // Return the parsed JSON as a Map
      return responseBody["id"];
    } else {
      // Handle error if the status code is not 200
      print('Error: ${response.statusCode}');
      return null;
    }
  }

  resetPassword(BuildContext context, String id, String password) async {
    final response = await HttpRequest(context).post(
        url: Constant.resetPassword,
        useToken: false,
        body: jsonEncode({
          "id": id,
          "password": password,
        }));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // final loginResponse = LoginResponse.fromJson(json.decode(response.body));

      // AuthService().setUser(context, loginResponse.data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: SelectableText("Reset Password Akun Sukses."),
      ));
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: SelectableText("Reset Password Akun gagal."),
      ));
      return false;
    }
  }

  logout(BuildContext context) async {
    final response = await HttpRequest(context).post(
      url: Constant.logout,
      useToken: true,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      await clearPrefs();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: SelectableText("Logout Sukses."),
      ));
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => IntroductionPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: SelectableText("Logout Gagal."),
      ));
    }
  }

  getMe(BuildContext context) async {
    final response = await HttpRequest(context).get(
      url: Constant.getUser,
      useToken: true,
    );

    if (response.statusCode == 200) {
      final user = User.fromJson(json.decode(response.body));
      AuthService().setUserName(user.userName);
      AuthService().setUserGender(user.gender);

      return user;
    } else {
      return false;
    }
  }

  Future<void> loginUserDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: SelectableText('Information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SelectableText(
                  'Login successfully',
                  key: Key('output'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MainPage()));
              },
            ),
          ],
        );
      },
    );
  }
}
