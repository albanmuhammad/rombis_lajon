import 'package:redbus_project/utils/utilities.dart';

class ListOrder {
  late List<Order> orders;

  ListOrder({required this.orders});

  // fromJson
  ListOrder.fromJson(List<dynamic> jsonList) {
    orders = jsonList.map((ticketJson) => Order.fromJson(ticketJson)).toList();
  }

  // toJson
  List<Map<String, dynamic>> toJson() {
    return orders.map((order) => order.toJson()).toList();
  }
}

class Order {
  String id;
  int price;
  int seat;
  int isPaid;
  String tikum;
  String name;
  int jumlahBarang;
  bool sampai;
  List<String> route;
  String createdAt;
  TicketOrder ticket;

  Order({
    required this.id,
    required this.price,
    required this.seat,
    required this.isPaid,
    required this.tikum,
    required this.jumlahBarang,
    required this.name,
    required this.sampai,
    required this.route,
    required this.createdAt,
    required this.ticket,
  });

  // fromJson
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      price: json['price'],
      seat: json['seat'],
      tikum: json['tikum'],
      jumlahBarang: json['jumlahBarang'],
      sampai: json['sampai'],
      name: json['name'],
      isPaid: json['isPaid'],
      createdAt: json['created_at'],
      route: List<String>.from(json['route']),
      ticket: TicketOrder.fromJson(json['ticket']),
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'name': name,
      'sampai': sampai,
      'tikum': tikum,
      'jumlahBarang': jumlahBarang,
      'seat': seat,
      'created_at': createdAt,
      'route': route,
      'ticket': ticket.toJson(),
    };
  }
}

class TicketOrder {
  String date;
  List<String> time;
  BusOrder bus;
  String currentLocation;

  TicketOrder(
      {required this.date,
      required this.time,
      required this.bus,
      required this.currentLocation});

  // fromJson
  factory TicketOrder.fromJson(Map<String, dynamic> json) {
    return TicketOrder(
      date: json['date'],
      time: List<String>.from(json['time']),
      bus: BusOrder.fromJson(json['bus']),
      currentLocation: json['current'],
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'time': time,
      'bus': bus.toJson(),
      'current': currentLocation
    };
  }
}

class BusOrder {
  String name;
  String description;

  BusOrder({
    required this.name,
    required this.description,
  });

  // fromJson
  factory BusOrder.fromJson(Map<String, dynamic> json) {
    return BusOrder(
      name: json['name'],
      description: json['description'],
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }
}
