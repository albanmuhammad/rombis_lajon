import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:redbus_project/model/bus/bus.dart';
import 'package:redbus_project/services/http_request.dart';
import 'package:redbus_project/utils/constant.dart';

class BusService {
  Future<ListBus> getAllBus(BuildContext context) async {
    final response =
        await HttpRequest(context).get(useToken: true, url: Constant.buses);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final bus = ListBus.fromJson(json.decode(response.body));

      return bus;
    } else {
      // Handle error response, or throw an exception
      throw Exception('Failed to load buses: ${response.statusCode}');
    }
  }

  Future<BusDetail> getBusDetail(BuildContext context, String busId) async {
    final String url = '${Constant.buses}/$busId'; // Append busId to the URL
    final response = await HttpRequest(context).get(useToken: true, url: url);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final bus = BusDetail.fromJson(json.decode(response.body));

      return bus;
    } else {
      // Handle error response, or throw an exception
      throw Exception('Failed to load buses: ${response.statusCode}');
    }
  }
}
