import 'package:flutter_test/flutter_test.dart';
import 'package:lords_arena/features/auth/presentation/cubit/login_cubit.dart';
import '../../../../mocks/mock_dependencies.mocks.dart';

void main() {
  group('LoginCubit Test', () {
    late MockAuthRemoteDataSource mockAuthRemoteDataSource;
    late MockUserRepository mockUserRepository;
    late LoginCubit loginCubit;

    setUp(() {
      mockAuthRemoteDataSource = MockAuthRemoteDataSource();
      mockUserRepository = MockUserRepository();
      loginCubit = LoginCubit(
        authRemoteDataSource: mockAuthRemoteDataSource,
        userRepository: mockUserRepository,
      );
    });

    test('Initial state is LoginInitial', () {
      expect(loginCubit.state.runtimeType.toString(), 'LoginInitial');
    });
  });
}
