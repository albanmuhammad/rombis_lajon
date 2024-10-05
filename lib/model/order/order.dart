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
  List<String> route;
  TicketOrder ticket;

  Order({
    required this.id,
    required this.price,
    required this.seat,
    required this.route,
    required this.ticket,
  });

  // fromJson
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      price: json['price'],
      seat: json['seat'],
      route: List<String>.from(json['route']),
      ticket: TicketOrder.fromJson(json['ticket']),
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'seat': seat,
      'route': route,
      'ticket': ticket.toJson(),
    };
  }
}

class TicketOrder {
  String date;
  List<String> time;
  BusOrder bus;

  TicketOrder({
    required this.date,
    required this.time,
    required this.bus,
  });

  // fromJson
  factory TicketOrder.fromJson(Map<String, dynamic> json) {
    return TicketOrder(
      date: json['date'],
      time: List<String>.from(json['time']),
      bus: BusOrder.fromJson(json['bus']),
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'time': time,
      'bus': bus.toJson(),
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
