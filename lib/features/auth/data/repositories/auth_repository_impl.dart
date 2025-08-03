import 'package:lords_arena/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lords_arena/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:lords_arena/features/auth/data/models/user_model.dart';
import 'package:lords_arena/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserModel?> login(String email, String password) async {
    final user = await remoteDataSource.login(email, password);
    if (user != null) {
      await localDataSource.saveUser(user);
    }
    return user;
  }

  @override
  Future<UserModel?> signup(
    String username,
    String email,
    String password,
  ) async {
    final user = await remoteDataSource.signup(username, email, password);
    if (user != null) {
      await localDataSource.saveUser(user);
    }
    return user;
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await localDataSource.saveUser(user);
  }

  @override
  Future<UserModel?> getUser() async {
    return await localDataSource.getUser();
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearUser();
  }
}
