import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linker/core/errors/exceptions.dart';
import 'package:linker/core/errors/failure.dart';
import 'package:linker/features/authentication/data/model/user_model.dart';
import 'package:linker/features/authentication/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthenticationDataSource {
  /// Uses [FirebaseAuth] to create new account
  /// IF success, returns [UserModel], else returns [FirebaseFailure]
  Future<User> register({String email, String password, String name});

  /// Uses [FirebaseAuth] to sign in to existing account
  /// IF success, returns [UserModel], else returns [FirebaseFailure]
  Future<User> signIn({String email, String password});

  /// Uses [FirebaseAuth] to sign out
  /// IF something went wrong, returns [FirebaseFailure]
  Future<void> signOut();

  /// Uses [FirebaseAuth] and [SharedPreferences] to sign in automatically
  /// IF success, returns [UserModel], else returns [FirebaseFailure]
  Future<User> signInAuto();
}

class AuthenticationDataSourceImpl extends AuthenticationDataSource {
  final SharedPreferences sharedPreferences;
  final FirebaseAuth firebaseAuth;
  final Firestore firestore;

  AuthenticationDataSourceImpl(
      {this.sharedPreferences, this.firebaseAuth, this.firestore});

  static const _authenticationKey = 'AUTH_KEY';

  @override
  Future<User> register({String email, String password, String name}) async {
    try {
      final AuthResult authResult = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final FirebaseUser user = authResult.user;

      final CollectionReference collection = firestore.collection('users');

      await collection.document(user.uid).setData({
        'groups': [],
        'links': [],
        'name': name,
        'types': [],
      });

      final newUser = UserModel(
        email: email,
        password: password,
        uid: user.uid,
      );

      await sharedPreferences.setString(
          _authenticationKey, jsonEncode(newUser.toJson()));

      return newUser;
    } catch (e) {
      print(e);
      throw Exception();
    }
  }

  @override
  Future<User> signIn({String email, String password}) async {
    try {
      final AuthResult authResult = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (authResult != null) {
        final FirebaseUser user = authResult.user;

        final newUser = UserModel(
          email: email,
          password: password,
          uid: user.uid,
        );

        return newUser;
      } else
        throw NoUserException();
    } catch (e) {
      print(e);
      throw Exception();
    }
  }

  @override
  Future<User> signInAuto() async {
    try {
      final UserModel user = UserModel.fromJson(
        json: jsonDecode(
          sharedPreferences.getString(_authenticationKey),
        ),
      );

      final AuthResult authResult =
          await firebaseAuth.signInWithEmailAndPassword(
              email: user.email, password: user.password);

      final FirebaseUser fUser = authResult.user;

      return UserModel(
        email: user.email,
        password: user.password,
        uid: fUser.uid,
      );
    } catch (e) {
      print(e);
      throw Exception();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      return await firebaseAuth.signOut();
    } catch (e) {
      print(e);
      throw Exception();
    }
  }
}
