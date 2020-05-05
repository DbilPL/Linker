import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linker/features/group_table/presentation/bloc/bloc.dart';
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
          textTheme: TextTheme(
            subtitle1: TextStyle(
              color: Colors.white,
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        textTheme: TextTheme(
          headline3: TextStyle(
            color: Color.fromRGBO(20, 37, 186, 1),
          ),
          headline5: TextStyle(
            color: Colors.white,
          ),
          caption: TextStyle(
            color: Color.fromRGBO(20, 37, 186, 1),
          ),
          button: TextStyle(
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

          if (state is FailureAuthenticationState) {
            await Future.delayed(
              Duration(seconds: 4),
            );
            Navigator.of(context).pushReplacementNamed('/sign-in');
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
                // TODO: change adding group to user
              }
            }
          },
          child: BlocListener<DynamicLinkBloc, DynamicLinkState>(
            listener: (context, state) {
              if (state is LoadLinkHandlerSuccess) {
                state.stream.listen(
                  (event) {
                    BlocProvider.of<GroupTableBloc>(context).add(
                      LoadGroupSnapshots(
                        event.queryParameters['group_name'],
                      ),
                    );
                  },
                );
              }
            },
            child: BlocBuilder<DynamicLinkBloc, DynamicLinkState>(
              builder: (context, state) {
                if (state is FailureLinkState) {
                  // on error try again (BlocProvider.of(context).add(LoadOnLinkHandler())))
                  return Scaffold();
                } else
                  return Scaffold(
                    body: Center(
                      child: Container(
                        width: 300,
                        height: 300,
                        child: FlareActor(
                          'assets/flare_animations/intro.flr',
                          animation: 'Untitled',
                        ),
                      ),
                    ),
                  );
              },
            ),
          ),
        ),
      ),
    );
  }
}
