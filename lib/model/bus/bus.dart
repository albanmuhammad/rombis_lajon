class Bus {
  late String id;
  late String name;
  late String description;
  late int storage;
  late List<String> route;
  late String type;
  late int seat;

  Bus(
      {required this.id,
      required this.name,
      required this.description,
      required this.storage,
      required this.route,
      required this.seat,
      required this.type});

  // fromJson constructor to deserialize JSON into a Bus object
  Bus.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'];
    description = json['description'];
    storage = json['storage'];
    route = List<String>.from(json['route']);
    seat = json['seat'];
    type = json['type'];
  }

  // toJson method to serialize the Bus object into JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'storage': storage,
      'route': route,
      'seat': seat,
      'type': type,
    };
  }
}

class ListBus {
  late List<Bus> data;

  ListBus({required this.data});

  // fromJson constructor to deserialize a list of JSON objects into ListBus
  ListBus.fromJson(List<dynamic> jsonList) {
    data = jsonList.map((busJson) => Bus.fromJson(busJson)).toList();
  }

  // toJson method to serialize ListBus into JSON
  List<dynamic> toJson() {
    return data.map((bus) => bus.toJson()).toList();
  }
}

class BusDetail {
  String id;
  String name;
  String description;
  List<String> route;
  List<String> tikum;
  String type;
  int storage;
  int seat;
  List<TicketInBus> ticket;

  BusDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.tikum,
    required this.route,
    required this.storage,
    required this.type,
    required this.seat,
    required this.ticket,
  });

  // fromJson method
  factory BusDetail.fromJson(Map<String, dynamic> json) {
    return BusDetail(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      route: List<String>.from(json['route']),
      tikum: List<String>.from(json['tikum']),
      type: json['type'],
      storage: json['storage'],
      seat: json['seat'],
      ticket: (json['ticket'] as List)
          .map((item) => TicketInBus.fromJson(item))
          .toList(),
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tikum': tikum,
      'route': route,
      'type': type,
      'seat': seat,
      'ticket': ticket.map((item) => item.toJson()).toList(),
    };
  }
}

class TicketInBus {
  String id;
  List<int> price;
  String date;
  String tipeIsi;
  int jumlahBarang;
  List<String> time;
  List<int> seat;

  TicketInBus({
    required this.id,
    required this.price,
    required this.tipeIsi,
    required this.jumlahBarang,
    required this.date,
    required this.time,
    required this.seat,
  });

  // fromJson method
  factory TicketInBus.fromJson(Map<String, dynamic> json) {
    return TicketInBus(
      id: json['id'],
      price: List<int>.from(json['price']),
      tipeIsi: json['tipeIsi'],
      jumlahBarang: json['jumlahBarang'],
      date: json['date'],
      time: List<String>.from(json['time']),
      seat: List<int>.from(json['seat']),
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'tipeIsi': tipeIsi,
      'jumlahBarang': jumlahBarang,
      'date': date,
      'time': time,
      'seat': seat,
    };
  }
}
