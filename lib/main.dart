import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linker/core/presentation/pages/loading_page.dart';
import 'package:linker/features/group_table/presentation/bloc/bloc.dart';
import 'package:linker/features/table/data/model/user_data_model.dart';
import 'package:linker/features/table/presentation/bloc/bloc.dart';
import 'package:linker/injection_container.dart';

import 'core/bloc_delegate.dart';
import 'core/presentation/bloc/bloc.dart';
import 'features/authentication/presentation/bloc/authentication_bloc.dart';
import 'features/authentication/presentation/bloc/authentication_event.dart';
import 'features/authentication/presentation/bloc/authentication_state.dart';
import 'features/authentication/presentation/pages/sign_in_page.dart';
import 'features/authentication/presentation/pages/sign_up_page.dart';
import 'features/table/presentation/pages/user_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // inits all instances from one point
  await di.init();

  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(
    MultiBlocProvider(
      child: MyApp(),
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => sl<AuthenticationBloc>()..add(AutoSignIn()),
        ),
        BlocProvider<DynamicLinkBloc>(
          create: (context) =>
              sl<DynamicLinkBloc>()..add(LoadOnLinkHandler()), // Link Bloc
        ),
        BlocProvider<UserTableBloc>(
          create: (context) => sl<UserTableBloc>(),
        ),
        BlocProvider<GroupTableBloc>(
          create: (context) => sl<GroupTableBloc>(), // Link Bloc
        ),
      ],
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Linker',
      theme: ThemeData(
        errorColor: Colors.red,
        backgroundColor: Colors.white,
        primaryColor: Color.fromRGBO(156, 169, 237, 1),
        buttonTheme: ButtonThemeData(
          buttonColor: Color.fromRGBO(20, 37, 186, 1),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          color: Color.fromRGBO(156, 169, 237, 1),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      routes: {
        '/sign-up': (context) => SignUpPage(),
        '/sign-in': (context) => SignInPage(),
        '/user': (context) => UserPage(),
      },
      home: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) async {
          if (state is Entered) {
            await Future.delayed(
              Duration(seconds: 3),
            );
            print('--entered!--');
            Navigator.of(context).pushReplacementNamed('/user');
          }
        },
        child: BlocListener<GroupTableBloc, GroupTableState>(
          listener: (context, state) async {
            if (state is SnapshotsLoaded) {
              // route to page with group table
              final authState =
                  BlocProvider.of<AuthenticationBloc>(context).state;
              final userTableState =
                  BlocProvider.of<UserTableBloc>(context).state;

              if (authState is Entered && userTableState is UserDataLoaded) {
                UserDataModel userDataModel = UserDataModel.fromJson(
                    (await userTableState.stream.last).data)
                  ..groupNameList.add(state.groupName);

                BlocProvider.of<UserTableBloc>(context).add(
                    UpdateUserData(authState.userModel.uid, userDataModel));
              }
            }
          },
          child: BlocBuilder<DynamicLinkBloc, DynamicLinkState>(
            builder: (context, state) {
              if (state is InitialDynamicLinkState) {
                // introduction animation
                return Scaffold(
                  body: Center(
                    child: Text('Animation'),
                  ),
                );
              }
              if (state is LoadLinkHandlerSuccess) {
                return StreamBuilder<Uri>(
                  stream: state.stream,
                  builder: (BuildContext context, AsyncSnapshot<Uri> snapshot) {
                    if (snapshot.hasData) {
                      BlocProvider.of<GroupTableBloc>(context).add(
                        LoadGroupSnapshots(
                          snapshot.data.queryParameters['group_name'],
                        ),
                      );
                    }
                    return Scaffold(
                      body: LoadingPage(),
                    );
                  },
                  initialData: null,
                );
              }
              if (state is FailureLinkState) {
                // on error try again (BlocProvider.of(context).add(LoadOnLinkHandler())))
                return Scaffold();
              } else
                return Scaffold();
            },
          ),
        ),
      ),
    );
  }
}
