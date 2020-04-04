import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linker/features/authentication/domain/usecases/sign_out.dart';
import 'package:mockito/mockito.dart';

import 'register_test.dart';

void main() {
  MockAuthenticationRepository repository;
  SignOut usecase;

  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = SignOut(repository);
  });
  test('should return user model', () async {
    when(repository.signOut()).thenAnswer((_) async => Right(doSomething()));

    final result = await usecase(NoParams());

    expect(result, Right(doSomething()));

    verify(repository.signOut());

    verifyNoMoreInteractions(repository);
  });
}

void doSomething() {}
