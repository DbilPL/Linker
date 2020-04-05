import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:linker/features/authentication/data/datasources/authentication_data_source.dart';
import 'package:linker/features/authentication/data/respositories/authentication_repository_impl.dart';
import 'package:linker/features/authentication/domain/usecases/register.dart';
import 'package:linker/features/authentication/domain/usecases/sign_in.dart';
import 'package:linker/features/authentication/domain/usecases/sign_in_auto.dart';
import 'package:linker/features/authentication/domain/usecases/sign_out.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // for app
  sl.registerSingleton(Firestore.instance);
  sl.registerSingleton(SharedPreferences.getInstance());
  sl.registerSingleton(FirebaseAuth.instance);
  sl.registerSingleton(DataConnectionChecker());

  // authentication
  sl.registerSingleton(AuthenticationDataSourceImpl(
    sharedPreferences: sl<SharedPreferences>(),
    firestore: sl<Firestore>(),
    firebaseAuth: sl<FirebaseAuth>(),
  ));
  sl.registerSingleton(AuthenticationRepositoryImpl(
    connectionChecker: sl<DataConnectionChecker>(),
    dataSource: sl<AuthenticationDataSource>(),
  ));

  sl.registerSingleton(Register(sl<AuthenticationRepositoryImpl>()));
  sl.registerSingleton(SignIn(sl<AuthenticationRepositoryImpl>()));
  sl.registerSingleton(SignInAuto(sl<AuthenticationRepositoryImpl>()));
  sl.registerSingleton(SignOut(sl<AuthenticationRepositoryImpl>()));
}