import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // for app

  sl.registerSingleton(Firestore.instance);
  sl.registerSingleton(SharedPreferences.getInstance());
  sl.registerSingleton(FirebaseAuth.instance);
}
