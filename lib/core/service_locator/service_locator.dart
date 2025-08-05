import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:lords_arena/core/storage/hive_storage.dart';
import 'package:lords_arena/features/auth/data/models/user_model.dart';
import 'package:lords_arena/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lords_arena/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:lords_arena/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lords_arena/features/auth/domain/repositories/auth_repository.dart';
import 'package:lords_arena/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lords_arena/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lords_arena/features/auth/presentation/cubit/login_cubit.dart';
import 'package:lords_arena/features/auth/presentation/cubit/signup_cubit.dart';
import 'package:lords_arena/features/user/data/datasources/user_local_data_source.dart';
import 'package:lords_arena/features/user/data/datasources/user_local_data_source_impl.dart';
import 'package:lords_arena/features/user/data/repositories/user_repository.dart';
import 'package:lords_arena/features/user/data/repositories/user_repository_impl.dart';
import 'package:lords_arena/features/user/presentation/cubit/user_cubit.dart';
import 'package:lords_arena/features/ingame/data/game_api_service.dart';
import 'package:lords_arena/features/ingame/data/player_api_service.dart';
import 'package:lords_arena/features/ingame/data/repositories/game_repository.dart';
import 'package:lords_arena/features/ingame/presentation/cubit/game_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final userBox = await Hive.openBox<UserModel>('userBox');
  final gameBox = await Hive.openBox('gameBox');
  sl.registerLazySingleton(
    () => HiveStorage(userBox: userBox, gameBox: gameBox),
  );

  sl.registerLazySingleton(() => AuthRemoteDataSource());

  sl.registerLazySingleton(() => AuthLocalDataSource());

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton(() => GameApiService());
  sl.registerLazySingleton(() => PlayerApiService());

  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(hiveStorage: sl()),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(userLocalDataSource: sl()),
  );

  sl.registerLazySingleton<GameRepository>(
    () => GameRepositoryImpl(
      gameApiService: sl(),
      playerApiService: sl(),
      userRepository: sl(),
    ),
  );

  sl.registerFactory(() => AuthBloc(repository: sl()));
  sl.registerFactory(() => AuthCubit(repository: sl()));

  sl.registerFactory(
    () => LoginCubit(authRepository: sl(), userRepository: sl()),
  );

  sl.registerFactory(
    () => SignupCubit(authRepository: sl(), userRepository: sl()),
  );

  sl.registerFactory(() => UserCubit(userRepository: sl()));

  sl.registerFactory(() => GameCubit(gameRepository: sl()));
}
