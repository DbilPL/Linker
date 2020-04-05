import 'dart:convert';

import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linker/features/authentication/data/datasources/authentication_data_source.dart';
import 'package:linker/features/authentication/data/model/user_model.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/usecases/sign_out_test.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MockFirestoreInstance mockFirestore;
  MockSharedPreferences mockSharedPreferences;
  MockFirebaseAuth mockFirebaseAuth;
  AuthenticationDataSourceImpl dataSource;

  final tUserModel = UserModel(
    name: 'Test',
    email: 'for_testing@gmail.com',
    password: '1234567',
    uid: 'aabbcc',
  );

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockFirestore = MockFirestoreInstance();

    mockFirestore.collection('users').document(tUserModel.uid).setData(
      {
        'groups': [],
        'links': [],
        'types': [],
        'name': tUserModel.name,
      },
    );
    mockFirebaseAuth = MockFirebaseAuth();
    dataSource = AuthenticationDataSourceImpl(
      firebaseAuth: mockFirebaseAuth,
      firestore: mockFirestore,
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('testing auth data source', () {
    test('should return user when sign in succeed', () async {
      final result = await dataSource.signIn(
          email: tUserModel.email, password: tUserModel.password);

      expect(result, tUserModel);

      verifyNoMoreInteractions(mockFirebaseAuth);
      verifyNoMoreInteractions(mockFirestore);
    });

    test(
        'should return user and use locally saved user data when sign in auto succeed',
        () async {
      when(mockSharedPreferences.getString('AUTH_KEY')).thenReturn(
        jsonEncode(tUserModel.toJson()),
      );

      final result = await dataSource.signInAuto();

      expect(result, tUserModel);

      verifyNoMoreInteractions(mockFirebaseAuth);
      verifyZeroInteractions(mockFirestore);
    });

    test('should sign out when sign out succeed', () async {
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async => doSomething());

      await dataSource.signOut();

      verifyZeroInteractions(mockFirestore);
      verifyZeroInteractions(mockSharedPreferences);
    });
  });
}
