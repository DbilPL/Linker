import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linker/core/presentation/bloc/bloc.dart';
import 'package:linker/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:linker/features/authentication/presentation/bloc/bloc.dart';
import 'package:linker/features/table/data/model/link_model.dart';
import 'package:linker/features/table/data/model/link_type_model.dart';
import 'package:linker/features/table/data/model/user_data_model.dart';
import 'package:linker/features/table/presentation/bloc/bloc.dart';
import 'package:linker/features/table/presentation/widgets/link_group_view.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    final authState = BlocProvider.of<AuthenticationBloc>(context).state;
    if (authState is Entered) {
      BlocProvider.of<UserTableBloc>(context)
          .add(LoadUserDataInitial(authState.userModel.uid));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DynamicLinkBloc, DynamicLinkState>(
      listener: (BuildContext context, DynamicLinkState state) {
        if (state is FailureAuthenticationState) {}
      },
      child: BlocBuilder<UserTableBloc, UserTableState>(
        builder: (context, state) {
          final authState = BlocProvider.of<AuthenticationBloc>(context).state;

          if (authState is Entered) {
            if (state.stream == null)
              return Scaffold(
                appBar: AppBar(),
                body: Container(),
              );
            else
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Main page',
                    style: Theme.of(context).textTheme.title,
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {},
                    ),
                    state is InitialUserTableState ||
                            state is LoadingUserTableState
                        ? CircularProgressIndicator()
                        : SizedBox(),
                  ],
                ),
                drawer: Drawer(),
                bottomNavigationBar: BottomAppBar(
                  color: Theme.of(context).primaryColor,
                  child: IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      size: 37,
                      color: Theme.of(context).backgroundColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/add-link-group');
                    },
                  ),
                ),
                body: StreamBuilder(
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      final userTableDataFromFirebase =
                          UserDataModel.fromJson(snapshot.data.data);

                      if (userTableDataFromFirebase.table != null) {
                        final List<LinkTypeModel> types =
                            userTableDataFromFirebase.types;

                        final List<LinkModel> links =
                            userTableDataFromFirebase.links;

                        List<List<LinkModel>> sortedLinks = [];

                        for (int i = 0; i < types.length; i++) {
                          sortedLinks.add([]);
                        }

                        for (int i = 0; i < links.length; i++) {
                          for (int j = 0; j < types.length; j++) {
                            if (links[i].type == types[j].name) {
                              sortedLinks[j].add(links[i]);
                            }
                          }
                        }

                        return ListView.builder(
                          itemCount: types.length,
                          itemBuilder: (BuildContext context, int index) {
                            return LinkGroupView(
                              links: sortedLinks[index],
                              type: types[index],
                            );
                          },
                        );
                      } else
                        return Center(
                          child: Text('No data!'),
                        );
                    } else
                      return Container();
                  },
                  initialData: null,
                  stream: state.stream,
                ),
              );
          } else
            return Scaffold(
              body: Center(
                child: Column(
                  children: <Widget>[
                    Text('How did you get there?!'),
                    RaisedButton(
                      child: Text('Back'),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/sign-in');
                      },
                    ),
                  ],
                ),
              ),
            );
        },
      ),
    );
  }
}
