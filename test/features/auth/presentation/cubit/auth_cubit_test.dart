import 'package:flutter_test/flutter_test.dart';
import 'package:lords_arena/features/auth/data/models/user_model.dart';
import 'package:lords_arena/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lords_arena/features/auth/presentation/cubit/auth_cubit.dart'
    hide AuthLoading;
import '../../../../mocks/mock_dependencies.mocks.dart';

void main() {
  group('AuthCubit Test', () {
    late MockAuthRepository mockRepository;
    late AuthCubit cubit;

    setUp(() {
      mockRepository = MockAuthRepository();
      cubit = AuthCubit(repository: mockRepository);
    });

    test('authenticate emits AuthLoading then AuthAuthenticated', () async {
      final fakeUser = UserModel(
        userId: '123',
        token: 'abc123',
        email: 'test@mail.com',
      );

      cubit.authenticate(fakeUser);

      await expectLater(
        cubit.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          predicate(
            (state) => state is AuthAuthenticated && state.user.userId == '123',
          ),
        ]),
      );
    });
  });
}
