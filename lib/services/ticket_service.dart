import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:redbus_project/model/ticket/ticket.dart';
import 'package:redbus_project/services/http_request.dart';
import 'package:redbus_project/utils/constant.dart';

class ticketService {
  Future<ListTicket> getAllTicket(BuildContext context) async {
    final response = await HttpRequest(context)
        .get(useToken: true, url: "${Constant.tickets}?is_available=true");

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
      int jumlahBarang,
      String departureRoute,
      String selectedDestination,
      List<String> seatName,
      List<String> selectedTikum,
      List<String> selectedGender) async {
    final response = await HttpRequest(context).post(
        url: Constant.booking,
        useToken: true,
        body: jsonEncode({
          "ticketId": ticketId,
          "userId": userId,
          "name": seatName,
          "jumlahBarang": jumlahBarang,
          "price": price,
          "seat": selectedSeat,
          "route": [departureRoute, selectedDestination],
          "tikum": selectedTikum,
          "gender": selectedGender
        }));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: SelectableText("Booking Tiket Sukses."),
      ));
      return true;
    } else {
      final decodedResponse = json.decode(response.body);
      String message = decodedResponse['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: SelectableText("Booking Tiket Gagal. ${message}"),
      ));
      return false;
    }
  }

  Future<dynamic> getUniquePrice(BuildContext context, int price) async {
    final response = await HttpRequest(context).post(
        url: Constant.uniquePrice,
        useToken: true,
        body: jsonEncode({"price": price}));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body;
    } else {
      return response.body;
    }
  }

  Future<bool> confirmationPayment(
      BuildContext context, int price, String createdAt) async {
    final response = await HttpRequest(context).post(
        url: Constant.paymentConfirmation,
        useToken: true,
        body:
            jsonEncode({"price": price, "created_at": createdAt, "isPaid": 1}));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: SelectableText("Pembayaran Sukses, menunggu konfirmasi."),
      ));
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: SelectableText("Pembayaran Gagal."),
      ));
      return false;
    }
  }

  Future<bool> absenTicket(BuildContext context, String id, bool sampai) async {
    final response = await HttpRequest(context).post(
        url: Constant.absen,
        useToken: true,
        body: jsonEncode({"id": id, "sampai": sampai}));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: SelectableText("Pembayaran Sukses, menunggu konfirmasi."),
      // ));
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: SelectableText("Absen Gagal."),
      ));
      return false;
    }
  }
}
