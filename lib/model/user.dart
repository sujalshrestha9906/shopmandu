import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  String token;

  @HiveField(1)
  String id;

  @HiveField(2)
  String email;

  @HiveField(3)
  String username;

  User(
      {required this.email,
      required this.id,
      required this.token,
      required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json['email'],
        id: json['id'],
        token: json['token'],
        username: json['username']);
  }
}
