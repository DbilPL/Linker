import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get_it/get_it.dart';
import 'package:linker/core/presentation/bloc/bloc.dart';
import 'package:linker/features/authentication/data/datasources/authentication_data_source.dart';
import 'package:linker/features/authentication/data/respositories/authentication_repository_impl.dart';
import 'package:linker/features/authentication/domain/usecases/register.dart';
import 'package:linker/features/authentication/domain/usecases/sign_in.dart';
import 'package:linker/features/authentication/domain/usecases/sign_in_auto.dart';
import 'package:linker/features/authentication/domain/usecases/sign_out.dart';
import 'package:linker/features/authentication/presentation/bloc/bloc.dart';
import 'package:linker/features/group_table/data/datasources/group_table_data_source.dart';
import 'package:linker/features/group_table/data/respositories/group_table_repository_impl.dart';
import 'package:linker/features/group_table/domain/usecases/create_new_group.dart';
import 'package:linker/features/group_table/domain/usecases/dynamic_link_stream.dart';
import 'package:linker/features/group_table/domain/usecases/generate_joining_link.dart';
import 'package:linker/features/group_table/domain/usecases/get_group_table_stream.dart';
import 'package:linker/features/group_table/domain/usecases/update_group_table_data.dart';
import 'package:linker/features/group_table/presentation/bloc/group_table_bloc.dart';
import 'package:linker/features/table/data/datasources/user_table_data_source.dart';
import 'package:linker/features/table/data/respositories/user_table_repository_impl.dart';
import 'package:linker/features/table/domain/usecases/get_user_data_stream.dart';
import 'package:linker/features/table/domain/usecases/update_user_data.dart';
import 'package:linker/features/table/presentation/bloc/user_table_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // for app
  sl.registerSingleton(Firestore.instance);
  sl.registerSingleton(await SharedPreferences.getInstance());
  sl.registerSingleton(FirebaseAuth.instance);
  sl.registerSingleton(FirebaseDynamicLinks.instance);
  sl.registerSingleton(DataConnectionChecker());

  // authentication
  sl.registerSingleton(AuthenticationDataSourceImpl(
    sharedPreferences: sl<SharedPreferences>(),
    firestore: sl<Firestore>(),
    firebaseAuth: sl<FirebaseAuth>(),
  ));
  sl.registerSingleton(AuthenticationRepositoryImpl(
    connectionChecker: sl<DataConnectionChecker>(),
    dataSource: sl<AuthenticationDataSourceImpl>(),
  ));
  sl.registerSingleton(Register(sl<AuthenticationRepositoryImpl>()));
  sl.registerSingleton(SignIn(sl<AuthenticationRepositoryImpl>()));
  sl.registerSingleton(SignInAuto(sl<AuthenticationRepositoryImpl>()));
  sl.registerSingleton(SignOut(sl<AuthenticationRepositoryImpl>()));
  sl.registerSingleton(AuthenticationBloc(
      sl<Register>(), sl<SignInAuto>(), sl<SignIn>(), sl<SignOut>()));

  // user table
  sl.registerSingleton(UserTableDataSourceImpl(sl<Firestore>()));
  sl.registerSingleton(UserTableRepositoryImpl(
      sl<UserTableDataSourceImpl>(), sl<DataConnectionChecker>()));
  sl.registerSingleton(GetUserDataStream(sl<UserTableRepositoryImpl>()));
  sl.registerSingleton(UpdateUserData(sl<UserTableRepositoryImpl>()));
  sl.registerSingleton(
      UserTableBloc(sl<GetUserDataStream>(), sl<UpdateUserData>()));

  // group table
  sl.registerSingleton(
      GroupTableDataSourceImpl(sl<Firestore>(), sl<FirebaseDynamicLinks>()));
  sl.registerSingleton(GroupTableRepositoryImpl(
      sl<GroupTableDataSourceImpl>(), sl<DataConnectionChecker>()));
  sl.registerSingleton(GetGroupTableStream(sl<GroupTableRepositoryImpl>()));
  sl.registerSingleton(UpdateGroupTableData(sl<GroupTableRepositoryImpl>()));
  sl.registerSingleton(GenerateJoiningLink(sl<GroupTableRepositoryImpl>()));
  sl.registerSingleton(CreateNewGroup(sl<GroupTableRepositoryImpl>()));
  sl.registerSingleton(DynamicLinkStream(sl<GroupTableRepositoryImpl>()));
  sl.registerSingleton(DynamicLinkBloc(sl<DynamicLinkStream>()));
  sl.registerSingleton(
      GroupTableBloc(sl<GetGroupTableStream>(), sl<CreateNewGroup>()));
}
