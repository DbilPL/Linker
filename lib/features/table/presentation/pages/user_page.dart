import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linker/core/presentation/bloc/bloc.dart';
import 'package:linker/core/presentation/bloc/dynamic_link_bloc.dart';
import 'package:linker/core/presentation/bloc/dynamic_link_event.dart';
import 'package:linker/core/presentation/pages/loading_page.dart';
import 'package:linker/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:linker/features/authentication/presentation/bloc/bloc.dart';
import 'package:linker/features/group_table/presentation/pages/groups_list.dart';
import 'package:linker/features/table/data/model/link_model.dart';
import 'package:linker/features/table/data/model/link_type_model.dart';
import 'package:linker/features/table/data/model/user_data_model.dart';
import 'package:linker/features/table/presentation/bloc/bloc.dart';
import 'package:linker/features/table/presentation/pages/add_link_group_page.dart';
import 'package:linker/features/table/presentation/widgets/link_group_view.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Stream<DocumentSnapshot> stream;
  bool isEditing = false;

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
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is SignedOut) {
            Navigator.of(context).pushReplacementNamed('/sign-in');
          }
          if (state is Entered) {
            if (state.msg != null) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).errorColor,
                  content: Text(
                    state.msg,
                  ),
                ),
              );
            }
          }
        },
        child: BlocListener<UserTableBloc, UserTableState>(
          listener: (BuildContext context, UserTableState state) {
            if (state is UserDataLoaded) {
              if (state.stream != null)
                setState(() {
                  stream = state.stream;
                });
            }
            if (state is FailureUserTableState) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).errorColor,
                  content: Text(
                    state.message,
                  ),
                ),
              );
            }
          },
          child: BlocBuilder<UserTableBloc, UserTableState>(
            builder: (context, state) {
              final authState =
                  BlocProvider.of<AuthenticationBloc>(context).state;

              if (authState is Entered) {
                if (stream == null)
                  return Scaffold(
                    appBar: AppBar(),
                    body: LoadingPage(),
                  );
                else
                  return Scaffold(
                    body: StreamBuilder(
                      stream: stream,
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          final userTableDataFromFirebase =
                              UserDataModel.fromJson(snapshot.data.data);

                          BlocProvider.of<DynamicLinkBloc>(context)
                              .add(LoadInitialLink());
                          BlocProvider.of<DynamicLinkBloc>(context).add(
                            SetOnLinkHandlerEvent(
                              (event) async {
                                if (event is PendingDynamicLinkData) {
                                  if (event.link != null) {
                                    await Future.delayed(Duration(seconds: 1));
                                    BlocProvider.of<UserTableBloc>(context).add(
                                      AddNewGroupToUserData(
                                        event
                                            .link.queryParameters['group_name'],
                                        UserDataModel.fromJson(
                                            snapshot.data.data),
                                        snapshot.data.reference,
                                      ),
                                    );
                                    await Future.delayed(Duration(seconds: 1));
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => GroupsList(
                                          snapshot: snapshot,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          );

                          if ((userTableDataFromFirebase != null &&
                              userTableDataFromFirebase.table != null)) {
                            final List<LinkTypeModel> types =
                                userTableDataFromFirebase.table.types;

                            final List<LinkModel> links =
                                userTableDataFromFirebase.table.links;

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

                            return BlocListener<DynamicLinkBloc,
                                DynamicLinkState>(
                              listener: (context, state) {
                                if (state is LoadLinkHandlerSuccess) {
                                  if (state.uri != null) {
                                    final groupName =
                                        state.uri.queryParameters['group_name'];

                                    BlocProvider.of<UserTableBloc>(context).add(
                                      AddNewGroupToUserData(
                                        groupName,
                                        UserDataModel.fromJson(
                                            snapshot.data.data),
                                        snapshot.data.reference,
                                      ),
                                    );

                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => GroupsList(
                                          snapshot: snapshot,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Scaffold(
                                appBar: AppBar(
                                  title: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                      ),
                                      Icon(
                                        Icons.person,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    Center(
                                      child: Text(
                                        isEditing ? 'Complete' : 'Edit',
                                        style: AppBarTheme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                          isEditing ? Icons.check : Icons.edit),
                                      onPressed: () {
                                        setState(() {
                                          isEditing = !isEditing;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                drawer: Drawer(
                                  elevation: 0.0,
                                  child: ListView(
                                    children: [
                                      UserAccountsDrawerHeader(
                                        accountName: Text(
                                            userTableDataFromFirebase.name),
                                        accountEmail:
                                            Text(authState.userModel.email),
                                        currentAccountPicture: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                            ),
                                            Icon(
                                              Icons.person,
                                              size: 65,
                                              color: AppBarTheme.of(context)
                                                  .iconTheme
                                                  .color,
                                            ),
                                          ],
                                        ),
                                      ),
                                      ListTile(
                                        onTap: () {
                                          final authState = BlocProvider.of<
                                                  AuthenticationBloc>(context)
                                              .state;

                                          if (authState is Entered)
                                            BlocProvider.of<AuthenticationBloc>(
                                                    context)
                                                .add(
                                              SignOutEvent(
                                                authState.userModel,
                                              ),
                                            );
                                        },
                                        title: Text(
                                          'Sign out',
                                        ),
                                      ),
                                      ListTile(
                                        onTap: () {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => GroupsList(
                                                snapshot: snapshot,
                                              ),
                                            ),
                                          );
                                        },
                                        title: Text(
                                          'Groups',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                bottomNavigationBar: BottomAppBar(
                                  color: Theme.of(context).primaryColor,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add_circle_outline,
                                      size: 37,
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddLinkGroupPage(
                                            snapshot: snapshot.data,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                body: types == []
                                    ? Center(
                                        child: Text('No data!'),
                                      )
                                    : ListView.builder(
                                        itemCount: types.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return LinkGroupView(
                                            links: sortedLinks[index],
                                            type: types[index],
                                            snapshot: snapshot.data,
                                            isEditing: isEditing,
                                          );
                                        },
                                      ),
                              ),
                            );
                          } else
                            return Center(
                              child: Text('No data!'),
                            );
                        } else if (snapshot.hasError)
                          return Container();
                        else
                          return LoadingPage();
                      },
                      initialData: null,
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
                            Navigator.of(context)
                                .pushReplacementNamed('/sign-in');
                          },
                        ),
                      ],
                    ),
                  ),
                );
            },
          ),
        ),
      ),
    );
  }
}
