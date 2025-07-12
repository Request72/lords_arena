import 'package:lords_arena/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lords_arena/features/auth/data/models/user_model.dart';

class AuthRepositoryImpl {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  Future<UserModel?> login(String email, String password) {
    return remoteDataSource.login(email, password); // ✅ Fixed
  }

  Future<UserModel?> signup(String username, String email, String password) {
    return remoteDataSource.signup(username, email, password); // ✅ Fixed
  }
}
