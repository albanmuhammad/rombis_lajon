import 'package:redbus_project/model/bus/bus.dart';

class Ticket {
  late String id;
  late String busId;
  late String date;
  late List<String> time;
  late List<int> price;
  late List<int> filledSeat;
  late Bus bus;

  Ticket({
    required this.id,
    required this.busId,
    required this.time,
    required this.date,
    required this.price,
    required this.filledSeat,
    required this.bus,
  });

  Ticket.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    busId = json["id_bus"];
    time = List<String>.from(json['time']);
    date = json["date"];
    price = List<int>.from(json['price']);
    filledSeat = List<int>.from(json['filledSeat']);
    bus = Bus.fromJson(json['bus']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_bus': busId,
      'time': time,
      'date': date,
      'price': price,
      'filledSeat': filledSeat,
      'bus': bus.toJson(),
    };
  }
}

class ListTicket {
  late List<Ticket> data;

  ListTicket({required this.data});

  // fromJson constructor to deserialize a list of JSON objects into ListBus
  ListTicket.fromJson(List<dynamic> jsonList) {
    data = jsonList.map((ticketJson) => Ticket.fromJson(ticketJson)).toList();
  }

  // toJson method to serialize ListBus into JSON
  List<dynamic> toJson() {
    return data.map((ticket) => ticket.toJson()).toList();
  }
}
