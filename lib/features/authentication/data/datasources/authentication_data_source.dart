import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  @override
  Future<User> register({String email, String password, String name}) {
    // TODO: implement register
    return null;
  }

  @override
  Future<User> signIn({String email, String password}) {
    // TODO: implement signIn
    return null;
  }

  @override
  Future<User> signInAuto() {
    // TODO: implement signInAuto
    return null;
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    return null;
  }
}
