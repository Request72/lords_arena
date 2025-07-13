import 'package:flutter_test/flutter_test.dart';
import 'package:lords_arena/features/auth/data/models/user_model.dart';
import 'package:mockito/mockito.dart';
import 'package:lords_arena/features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../mocks/mock_dependencies.mocks.dart';

void main() {
  group('AuthBloc Test', () {
    late MockAuthRepositoryImpl mockRepository;
    late AuthBloc bloc;

    setUp(() {
      mockRepository = MockAuthRepositoryImpl();
      bloc = AuthBloc(repository: mockRepository);
    });

    test(
      'LoginRequested emits AuthLoading then AuthSuccess with UserModel',
      () async {
        final fakeUser = UserModel(
          userId: 'u1',
          token: 'mock_token',
          email: '',
        );

        when(mockRepository.login(any, any)).thenAnswer((_) async => fakeUser);

        bloc.add(LoginRequested('test@mail.com', '123456'));

        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            predicate(
              (state) => state is AuthSuccess && state.user.userId == 'u1',
            ),
          ]),
        );
      },
    );
  });
}
