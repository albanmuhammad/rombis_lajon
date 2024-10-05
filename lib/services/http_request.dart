import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';
import 'package:redbus_project/screen/login_page.dart';
import 'package:redbus_project/services/auth_service.dart';
import 'package:redbus_project/utils/constant.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpRequest {
  late BuildContext _context;
  late SharedPreferences sp;

  HttpRequest(BuildContext context) {
    _context = context;
  }

  Future<http.Response> get(
      {String url = "", bool useToken = true, int timeout = 5}) async {
    String token = "";

    if (kDebugMode) debugPrint('[GET] $url');
    if (useToken) {
      token = await AuthService().getToken();
    }
    try {
      developer.log(Constant.baseAPIUrl + url, name: 'GET API URL');
      var res = await http
          .get(
            Uri.parse(Constant.baseAPIUrl + url),
            headers: _genHttpHeader(token),
          )
          .timeout(Duration(minutes: timeout));

      return _httpResHandling(res);
    } catch (e) {
      if (kDebugMode) debugPrint("HTTPREQUEST GET: " + e.toString());
      return _httpResHandling(e);
    }
  }

  Future<http.Response> post(
      {String url = "", body, bool useToken = true}) async {
    String token = "";

    if (useToken) {
      token = await AuthService().getToken();
    }

    if (kDebugMode) debugPrint('[POST] $url');

    try {
      developer.log(Constant.baseAPIUrl + url, name: 'POST API URL');
      developer.log(body.toString(), name: 'POST API Body');

      var res = await http.post(
        Uri.parse(Constant.baseAPIUrl + url),
        headers: _genHttpHeader(token),
        body: body,
      );

      return _httpResHandling(res);
    } catch (e, stacktrace) {
      print('Stacktrace: ' + stacktrace.toString());
      return _httpResHandling(e);
    }
  }

  Future<http.Response> put(
      {String url = "", body, bool useToken = true}) async {
    String token = "";

    if (useToken) {
      token = await AuthService().getToken();
    }

    if (kDebugMode) ('[PUT] $url');

    try {
      developer.log(Constant.baseAPIUrl + url, name: 'PUT API URL');
      developer.log(body.toString(), name: 'PUT API Body');
      var res = await http.put(
        Uri.parse(Constant.baseAPIUrl + url),
        headers: _genHttpHeader(token),
        body: body,
      );
      return _httpResHandling(res);
    } catch (e) {
      if (kDebugMode) debugPrint("HTTPREQUEST PUT: " + e.toString());
      return _httpResHandling(e);
    }
  }

  // Future<http.Response> delete({String url = "", bool useToken = true}) async {
  //   String bearerToken;
  //   int tokenStatus;

  //   if (useToken) {
  //     bearerToken = await AuthService().getBearerToken();
  //     tokenStatus = await RefreshToken().checkToken(_context, bearerToken);
  //     bearerToken = await AuthService().getBearerToken();
  //   } else {
  //     tokenStatus = 1;
  //   }

  //   if (kDebugMode) debugPrint('[DEL] $url');

  //   if (tokenStatus == 1) {
  //     try {
  //       developer.log(Constant.apiUrl + url, name: 'DELETE API URL');
  //       var res = await http.delete(
  //         Uri.parse(Constant.apiUrl + url),
  //         headers: _genHttpHeader(useToken, bearerToken),
  //       );

  //       return _httpResHandling(res);
  //     } catch (e) {
  //       if (kDebugMode) debugPrint("HTTPREQUEST GET: " + e.toString());
  //       _httpResHandling(e);
  //     }
  //   } else {
  //     // logout();
  //     return _tokenExpiredHandling();
  //   }
  // }

  Map<String, String> _genHttpHeader(String token) {
    return {
      HttpHeaders.contentTypeHeader: "application/json",
      if (token != "") HttpHeaders.cookieHeader: "auth_session=$token",
      "origin": Constant.baseUrl,
    };
  }

  _tokenExpiredHandling() {
    ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
      content: SelectableText(
          'Your access has expired, please re-login to your account again.'),
    ));
    return new http.Response(
        '{"message": "Your access has expired, please re-login to your account again."}',
        401);
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('isLogin', false);
    await prefs.remove('token');
    await prefs.clear();
    Navigator.of(_context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  _httpResHandling(dynamic res) {
    if (res.statusCode == 200) {
      return res;
    } else if (res.statusCode == 401) {
      logout();
      return _tokenExpiredHandling();
    } else {
      // ApiResponse apiRsponse = ApiResponse.fromJson(json.decode(res?.body));

      // if (apiRsponse.message != "No customer found") {
      //   ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
      //     content: SelectableText(
      //         "Error : ${apiRsponse.code.toString()} , Message : ${apiRsponse.message.toString()}"),
      //   ));
      // }

      return res;
    }
  }
}
