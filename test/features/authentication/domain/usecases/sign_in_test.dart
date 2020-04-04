import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linker/features/authentication/data/model/user_model.dart';
import 'package:linker/features/authentication/domain/usecases/register.dart';
import 'package:linker/features/authentication/domain/usecases/sign_in.dart';
import 'package:mockito/mockito.dart';

import 'register_test.dart';

void main() {
  MockAuthenticationRepository repository;
  SignIn usecase;

  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = SignIn(repository);
  });

  final tUserModel = UserModel(
      name: 'ljcndjckjd', email: 'asdljndcdsjcn', password: 'kcjnsdjcnjncjd');

  test('should return user model', () async {
    when(repository.signIn(
            email: tUserModel.email, password: tUserModel.password))
        .thenAnswer((_) async => Right(tUserModel));

    final result = await usecase(AuthenticationParams(
        email: tUserModel.email, password: tUserModel.password));

    expect(result, Right(tUserModel));

    verify(repository.signIn(
        email: tUserModel.email, password: tUserModel.password));

    verifyNoMoreInteractions(repository);
  });
}
