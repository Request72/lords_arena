import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:lords_arena/core/storage/hive_storage.dart';
import 'package:lords_arena/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lords_arena/features/auth/presentation/cubit/login_cubit.dart';
import 'package:lords_arena/features/auth/presentation/cubit/signup_cubit.dart';
import 'package:lords_arena/features/user/data/datasources/user_local_data_source.dart';
import 'package:lords_arena/features/user/data/datasources/user_local_data_source_impl.dart';
import 'package:lords_arena/features/user/data/repositories/user_repository.dart';
import 'package:lords_arena/features/user/data/repositories/user_repository_impl.dart';
import 'package:lords_arena/features/user/presentation/cubit/user_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final userBox = await Hive.openBox('userBox');
  sl.registerLazySingleton(() => HiveStorage(userBox: userBox));

  // ✅ Register remote data source for login/signup API calls
  sl.registerLazySingleton(() => AuthRemoteDataSource());

  // ✅ Local user storage layer
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(hiveStorage: sl()),
  );

  // ✅ User repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(userLocalDataSource: sl()),
  );

  // ✅ Cubits
  sl.registerFactory(
    () => LoginCubit(authRemoteDataSource: sl(), userRepository: sl()),
  );

  sl.registerFactory(
    () => SignupCubit(authRemoteDataSource: sl(), userRepository: sl()),
  );

  sl.registerFactory(() => UserCubit(userRepository: sl()));
}
