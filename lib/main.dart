import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linker/features/group_table/presentation/bloc/bloc.dart';
import 'package:linker/features/group_table/presentation/pages/group_table_page.dart';
import 'package:linker/features/group_table/presentation/pages/groups_list.dart';
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
          create: (context) => sl<DynamicLinkBloc>()
            ..add(LoadInitialLink((event) async {
              if (event is PendingDynamicLinkData) {
                final authState =
                    BlocProvider.of<AuthenticationBloc>(context).state;
                final userTableState =
                    BlocProvider.of<UserTableBloc>(context).state;

                print(authState is Entered && userTableState is UserDataLoaded);

                if (authState is Entered && userTableState is UserDataLoaded) {
                  final navigator = Navigator.of(context);

                  final streamList = await userTableState.stream.toList();

                  final last = streamList.last;

                  if (navigator.canPop()) {
                    navigator.pop();
                  }

                  navigator.pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => GroupTablePage(
                        snapshot: last,
                      ),
                    ),
                  );
                }
              }
            })), // Link Bloc
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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Timer _timerLink;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('resumed');
      _timerLink = new Timer(const Duration(milliseconds: 850), () {
        BlocProvider.of<DynamicLinkBloc>(context)
            .add(LoadInitialLink((event) async {
          if (event is PendingDynamicLinkData) {
            final authState =
                BlocProvider.of<AuthenticationBloc>(context).state;
            final userTableState =
                BlocProvider.of<UserTableBloc>(context).state;

            print(authState is Entered && userTableState is UserDataLoaded);

            if (authState is Entered && userTableState is UserDataLoaded) {
              final navigator = Navigator.of(context);

              final streamList = await userTableState.stream.toList();

              final last = streamList.last;

              if (navigator.canPop()) {
                navigator.pop();
              }

              navigator.pushReplacement(
                MaterialPageRoute(
                  builder: (context) => GroupTablePage(
                    snapshot: last,
                  ),
                ),
              );
            }
          }
        }));
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

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
        '/groups-list': (context) => GroupsList(),
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
                final navigator = Navigator.of(context);

                final streamList = await userTableState.stream.toList();

                final last = streamList.last;

                if (navigator.canPop()) {
                  navigator.pop();
                }

                navigator.pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GroupTablePage(
                      snapshot: last,
                    ),
                  ),
                );
              }
            }
          },
          child: BlocListener<DynamicLinkBloc, DynamicLinkState>(
            listener: (context, state) async {
              if (state is LoadLinkHandlerSuccess) {
                await Future.delayed(Duration(seconds: 5));

                final authState =
                    BlocProvider.of<AuthenticationBloc>(context).state;

                if (authState is Entered) {
                  final groupName = state.uri.queryParameters['group_name'];

                  BlocProvider.of<GroupTableBloc>(context).add(
                    LoadGroupSnapshots(
                      groupName,
                    ),
                  );
                } else
                  Navigator.of(context).pushReplacementNamed('/sign-in');
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
