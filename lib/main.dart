import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linker/injection_container.dart';

import 'core/bloc_delegate.dart';
import 'core/presentation/bloc/bloc.dart';
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
        BlocProvider<DynamicLinkBloc>(
          create: (context) =>
              sl<DynamicLinkBloc>()..add(LoadOnLinkHandler()), // Link Bloc
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
      routes: {},
      home: BlocBuilder<DynamicLinkBloc, DynamicLinkState>(
        builder: (context, state) {
          if (state is InitialDynamicLinkState) {
            // introduction animation
            return Scaffold();
          }
          if (state is LoadLinkHandlerSuccess) {
            return StreamBuilder<Uri>(
              stream: state.stream,
              builder: (BuildContext context, AsyncSnapshot<Uri> snapshot) {
                if (snapshot.hasData) {
                  // add user to group and open group page
                  // snapshot.data.queryParameters['group_name'];
                } else {
                  // do nothing
                }
                return Scaffold();
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
    );
  }
}
