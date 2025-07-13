import 'package:flutter_test/flutter_test.dart';
import 'package:lords_arena/features/auth/data/models/user_model.dart';
import 'package:lords_arena/features/auth/presentation/cubit/auth_cubit.dart';

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

      final states = await cubit.stream.take(2).toList();

      expect(states[0], isA<AuthLoading>());
      expect(states[1], isA<AuthAuthenticated>());
      expect((states[1] as AuthAuthenticated).user.userId, '123');
    });
  });
}
