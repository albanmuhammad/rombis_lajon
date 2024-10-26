import 'package:redbus_project/utils/utilities.dart';

class User {
  late String id;
  late int role;
  late bool isActive;
  late String userName;

  User(
      {required this.id,
      required this.isActive,
      required this.role,
      required this.userName});

  User.fromJson(Map<String, dynamic> json) {
    id = Utilities.parseString(json['id']);
    role = Utilities.parseInt(json['role']);
    isActive = Utilities.parseBool(json['isActive']);
    userName = Utilities.parseString(json['username']);
  }
}
