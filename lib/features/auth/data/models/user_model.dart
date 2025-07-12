import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String token;

  UserModel({required this.userId, required this.email, required this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user']['_id'],
      email: json['user']['email'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'email': email,
    'token': token,
  };
}
