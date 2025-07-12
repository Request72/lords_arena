part of 'user_cubit.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoaded extends UserState {
  final String email;
  final String userId;

  UserLoaded({required this.email, required this.userId});
}

class UserLoggedOut extends UserState {}
