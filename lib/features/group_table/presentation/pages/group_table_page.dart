import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linker/core/presentation/pages/loading_page.dart';
import 'package:linker/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:linker/features/authentication/presentation/bloc/authentication_state.dart';
import 'package:linker/features/group_table/data/model/group_link_table_model.dart';
import 'package:linker/features/group_table/presentation/bloc/bloc.dart';
import 'package:linker/features/group_table/presentation/widgets/link_group_view_for_group.dart';
import 'package:linker/features/table/data/model/link_model.dart';
import 'package:linker/features/table/data/model/link_type_model.dart';
import 'package:linker/features/table/data/model/user_data_model.dart';
import 'package:linker/features/table/presentation/bloc/bloc.dart';
import 'package:share/share.dart';

import 'file:///D:/Main/MainProjects/linker/lib/features/group_table/presentation/pages/add_link_group_for_group.dart';

class GroupTablePage extends StatefulWidget {
  final DocumentSnapshot snapshot;

  GroupTablePage({Key key, this.snapshot}) : super(key: key);

  @override
  _GroupTablePageState createState() => _GroupTablePageState();
}

class _GroupTablePageState extends State<GroupTablePage> {
  bool isEditing = false;
  Stream<DocumentSnapshot> groupStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<GroupTableBloc, GroupTableState>(
        listener: (BuildContext context, GroupTableState state) {
          if (state is SnapshotsLoaded) {
            if (state.stream != null)
              setState(() {
                groupStream = state.stream;
              });

            if (state.joiningLink != null) Share.share(state.joiningLink);
          }
          if (state is FailureGroupTableState) {
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
        child: StreamBuilder(
          initialData: null,
          builder: (context, AsyncSnapshot<DocumentSnapshot> _snapshot) {
            return BlocBuilder<UserTableBloc, UserTableState>(
              builder: (BuildContext context, UserTableState state) {
                final authState =
                    BlocProvider.of<AuthenticationBloc>(context).state;

                if (authState is Entered) {
                  if (groupStream != null)
                    return StreamBuilder(
                      stream: groupStream,
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (widget.snapshot.data != null &&
                            snapshot.data != null) {
                          final userDataModel =
                              UserDataModel.fromJson(widget.snapshot.data);
                          final groupDataModel =
                              GroupLinkTableModel.fromJson(_snapshot.data.data);

                          final List<LinkTypeModel> types =
                              groupDataModel.types;

                          final List<LinkModel> links = groupDataModel.links;

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

                          return Scaffold(
                            appBar: AppBar(
                              title: Row(
                                children: [
                                  Text(
                                    groupDataModel.tableName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        .copyWith(fontSize: 22),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Stack(
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
                                    accountName: Text(userDataModel.name),
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
                                      Navigator.of(context)
                                          .pushReplacementNamed('/user');
                                    },
                                    title: Text(
                                      'Back to user page',
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      BlocProvider.of<GroupTableBloc>(context)
                                          .add(
                                        GenerateJoiningLinkEvent(
                                            groupDataModel.tableName),
                                      );
                                    },
                                    title: Text(
                                      'Share joining link',
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
                                          AddLinkGroupForGroup(
                                        snapshot: _snapshot.data,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            body: ListView.builder(
                              itemBuilder: (context, index) {
                                return LinkGroupViewForGroup(
                                  type: types[index],
                                  links: sortedLinks[index],
                                  snapshot: _snapshot.data,
                                  isEditing: isEditing,
                                );
                              },
                              itemCount: types.length,
                            ),
                          );
                        } else
                          return LoadingPage();
                      },
                    );
                  else
                    return LoadingPage();
                } else {
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
                }
              },
            );
          },
          stream: groupStream,
        ),
      ),
    );
  }
}
