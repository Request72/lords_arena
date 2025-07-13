import 'package:lords_arena/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lords_arena/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lords_arena/features/auth/domain/repositories/auth_repository.dart';
import 'package:lords_arena/features/user/data/repositories/user_repository.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  AuthRemoteDataSource,
  UserRepository,
  AuthRepositoryImpl,
  AuthRepository,
])
void main() {}
