import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:redbus_project/model/ticket/ticket.dart';
import 'package:redbus_project/services/http_request.dart';
import 'package:redbus_project/utils/constant.dart';

class ticketService {
  Future<ListTicket> getAllTicket(BuildContext context) async {
    final response =
        await HttpRequest(context).get(useToken: true, url: Constant.tickets);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = ListTicket.fromJson(json.decode(response.body));

      return data;
    } else {
      // Handle error response, or throw an exception
      throw Exception('Failed to load buses: ${response.statusCode}');
    }
  }

  Future<bool> bookingTicket(
      BuildContext context,
      String userId,
      String ticketId,
      int price,
      List<int> selectedSeat,
      String departureRoute,
      String selectedDestination) async {
    final response = await HttpRequest(context).post(
        url: Constant.booking,
        useToken: true,
        body: jsonEncode({
          "id_ticket": ticketId,
          "id_user": userId,
          "price": price,
          "seat": selectedSeat,
          "route": [departureRoute, selectedDestination]
        }));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: SelectableText("Booking Tiket Sukses."),
      ));
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: SelectableText("Booking Tiket Gagal."),
      ));
      return false;
    }
  }
}
