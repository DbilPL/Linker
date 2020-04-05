import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linker/features/authentication/data/model/user_model.dart';
import 'package:linker/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:linker/features/authentication/domain/usecases/register.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  MockAuthenticationRepository repository;
  Register usecase;

  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = Register(repository);
  });

  final tUserModel =
      UserModel(email: 'asdljndcdsjcn', password: 'kcjnsdjcnjncjd');

  test('should return user model', () async {
    when(repository.register(
            email: tUserModel.email, password: tUserModel.password))
        .thenAnswer((_) async => Right(tUserModel));

    final result = await usecase(AuthenticationParams(
        email: tUserModel.email,
        password: tUserModel.password,
        name: tUserModel.name));

    expect(result, Right(tUserModel));

    verify(repository.register(
        email: tUserModel.email,
        password: tUserModel.password,
        name: tUserModel.name));

    verifyNoMoreInteractions(repository);
  });
}
