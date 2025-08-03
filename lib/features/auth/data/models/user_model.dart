import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String username;

  @HiveField(3)
  final String token;

  UserModel({
    required this.userId,
    required this.email,
    required this.username,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? json['_id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'email': email,
    'username': username,
    'token': token,
  };
}
