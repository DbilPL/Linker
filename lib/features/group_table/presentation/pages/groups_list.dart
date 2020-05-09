import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linker/core/presentation/pages/loading_page.dart';
import 'package:linker/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:linker/features/authentication/presentation/bloc/authentication_state.dart';
import 'package:linker/features/group_table/presentation/bloc/bloc.dart';
import 'package:linker/features/group_table/presentation/widgets/group_name_view.dart';
import 'package:linker/features/table/data/model/user_data_model.dart';
import 'package:linker/features/table/presentation/bloc/bloc.dart';

import 'add_group.dart';

class GroupsList extends StatefulWidget {
  final AsyncSnapshot<DocumentSnapshot> snapshot;

  GroupsList({Key key, this.snapshot}) : super(key: key);

  @override
  _GroupsListState createState() => _GroupsListState();
}

class _GroupsListState extends State<GroupsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<UserTableBloc, UserTableState>(
        listener: (context, state) async {
          print('yay?');
          if (state is FailureUserTableState) {
            await Future.delayed(Duration(seconds: 2));
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
        child: BlocListener<GroupTableBloc, GroupTableState>(
          listener: (context, state) {
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
          child: BlocBuilder<UserTableBloc, UserTableState>(
            builder: (context, state) {
              final authState =
                  BlocProvider.of<AuthenticationBloc>(context).state;

              if (widget.snapshot != null) {
                final userDataModel =
                    UserDataModel.fromJson(widget.snapshot.data.data);

                final groupNameList = userDataModel.groupNameList;

                if (authState is Entered) {
                  return Scaffold(
                    appBar: AppBar(
                      actions: [
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AddGroup(
                                  snapshot: widget.snapshot.data,
                                  uid: authState.userModel.uid,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                      title: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          Icon(
                            Icons.person,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    drawer: Drawer(
                      elevation: 0.0,
                      child: ListView(
                        children: [
                          UserAccountsDrawerHeader(
                            accountName: Text(userDataModel.name),
                            accountEmail: Text(authState.userModel.email),
                            currentAccountPicture: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                                Icon(
                                  Icons.person,
                                  size: 65,
                                  color:
                                      AppBarTheme.of(context).iconTheme.color,
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
                        ],
                      ),
                    ),
                    body: groupNameList == []
                        ? Center(
                            child: Text(
                              'No data!',
                            ),
                          )
                        : ListView.builder(
                            itemCount: groupNameList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GroupNameView(
                                groupName: groupNameList[index],
                                snapshot: widget.snapshot.data,
                              );
                            },
                          ),
                  );
                } else
                  return Center(
                    child: Text('No data!'),
                  );
              } else
                return LoadingPage();
            },
          ),
        ),
      ),
    );
  }
}
