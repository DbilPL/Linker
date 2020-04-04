import 'package:dartz/dartz.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linker/core/errors/failure.dart';
import 'package:linker/features/authentication/data/datasources/authentication_data_source.dart';
import 'package:linker/features/authentication/data/model/user_model.dart';
import 'package:linker/features/authentication/data/respositories/authentication_repository_impl.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationDataSource extends Mock
    implements AuthenticationDataSource {}

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  MockAuthenticationDataSource mockAuthenticationDataSource;
  MockDataConnectionChecker mockDataConnectionChecker;
  AuthenticationRepositoryImpl repository;

  setUp(() {
    mockAuthenticationDataSource = MockAuthenticationDataSource();
    mockDataConnectionChecker = MockDataConnectionChecker();
    repository = AuthenticationRepositoryImpl(
      dataSource: mockAuthenticationDataSource,
      connectionChecker: mockDataConnectionChecker,
    );
  });
  final tUserModel = UserModel(
    name: 'wowowoo',
    email: 'yayayaya',
    password: 'asojndjvbhdisb',
    uid: 'kfjndsicidsisndisc',
  );

  group('device is offline', () {
    setUp(() {
      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) async => false);
    });

    test('should return failure when device is not connected', () async {
      final result1 = await repository.signOut();
      final result2 = await repository.signInAuto();
      final result3 = await repository.signIn(
          password: tUserModel.password, email: tUserModel.email);
      final result4 = await repository.register(
          password: tUserModel.password,
          email: tUserModel.email,
          name: tUserModel.email);

      expect(result1, Left(ConnectionFailure()));
      expect(result2, Left(ConnectionFailure()));
      expect(result3, Left(ConnectionFailure()));
      expect(result4, Left(ConnectionFailure()));
    });
  });
}
