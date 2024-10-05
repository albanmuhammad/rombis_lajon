import 'package:redbus_project/utils/utilities.dart';

class User {
  late String id;
  late int role;
  late int isActive;
  late String userName;

  User(
      {required this.id,
      required this.isActive,
      required this.role,
      required this.userName});

  User.fromJson(Map<String, dynamic> json) {
    id = Utilities.parseString(json['id']);
    role = Utilities.parseInt(json['role']);
    isActive = Utilities.parseInt(json['is_active']);
    userName = Utilities.parseString(json['username']);
  }
}
