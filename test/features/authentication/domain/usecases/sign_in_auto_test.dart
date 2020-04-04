import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linker/features/authentication/data/model/user_model.dart';
import 'package:linker/features/authentication/domain/usecases/sign_in_auto.dart';
import 'package:linker/features/authentication/domain/usecases/sign_out.dart';
import 'package:mockito/mockito.dart';

import 'register_test.dart';

void main() {
  MockAuthenticationRepository repository;
  SignInAuto usecase;

  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = SignInAuto(repository);
  });

  final tUserModel = UserModel(
      name: 'ljcndjckjd', email: 'asdljndcdsjcn', password: 'kcjnsdjcnjncjd');

  test('should return user model', () async {
    when(repository.signInAuto()).thenAnswer((_) async => Right(tUserModel));

    final result = await usecase(NoParams());

    expect(result, Right(tUserModel));

    verify(repository.signInAuto());

    verifyNoMoreInteractions(repository);
  });
}
