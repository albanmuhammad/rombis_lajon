import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:redbus_project/model/order/order.dart';
import 'package:redbus_project/services/http_request.dart';
import 'package:redbus_project/utils/constant.dart';

class OrderService {
  Future<ListOrder> getUserOrder(BuildContext context, String userId) async {
    final String url = '${Constant.booking}/$userId'; // Append busId to the URL
    final response = await HttpRequest(context).get(useToken: true, url: url);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = ListOrder.fromJson(json.decode(response.body));

      return data;
    } else {
      // Handle error response, or throw an exception
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: SelectableText("Failed to load user order."),
      ));
      throw Exception('Failed to load buses: ${response.statusCode}');
    }
  }
}
