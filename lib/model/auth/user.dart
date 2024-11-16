import 'package:redbus_project/utils/utilities.dart';

class User {
  late String id;
  late int role;
  late bool isActive;
  late String gender;
  late String userName;
  late String phoneNumber;
  late String fullName;

  User(
      {required this.id,
      required this.isActive,
      required this.role,
      required this.gender,
      required this.userName,
      required this.phoneNumber,
      required this.fullName});

  User.fromJson(Map<String, dynamic> json) {
    id = Utilities.parseString(json['id']);
    role = Utilities.parseInt(json['role']);
    gender = Utilities.parseString(json['gender']);
    isActive = Utilities.parseBool(json['isActive']);
    userName = Utilities.parseString(json['username']);
    phoneNumber = json["noTelepon"];
    fullName = json["namaLengkap"];
  }
}
