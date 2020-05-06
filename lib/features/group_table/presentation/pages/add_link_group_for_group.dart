import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:linker/features/group_table/data/model/group_link_table_model.dart';
import 'package:linker/features/group_table/presentation/bloc/group_table_bloc.dart';
import 'package:linker/features/group_table/presentation/bloc/group_table_event.dart';
import 'package:linker/features/group_table/presentation/bloc/group_table_state.dart';
import 'package:linker/features/table/data/model/link_type_model.dart';
import 'package:linker/features/table/presentation/bloc/bloc.dart';

class AddLinkGroupForGroup extends StatefulWidget {
  final DocumentSnapshot snapshot;

  AddLinkGroupForGroup({Key key, this.snapshot}) : super(key: key);

  @override
  _AddLinkGroupForGroupState createState() => _AddLinkGroupForGroupState();
}

class _AddLinkGroupForGroupState extends State<AddLinkGroupForGroup> {
  TextEditingController _groupNameController = TextEditingController(text: '');
  int importanceValue = 0;
  Color selectedColor = Colors.red;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<GroupTableBloc, GroupTableState>(
        listener: (context, state) {
          if (state is SnapshotsLoaded) {
            Navigator.of(context).pop();
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
        child: BlocBuilder<GroupTableBloc, GroupTableState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Group name'),
                    controller: _groupNameController,
                  ),
                  ListTile(
                    title: Text('Importance'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          changeImportance(1);
                        },
                      ),
                      Text(
                        '$importanceValue',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          changeImportance(-1);
                        },
                      ),
                    ],
                  ),
                  ListTile(
                    onTap: () {
                      closeKeyBoard();
                      _openColorPicker();
                    },
                    title: Text(
                      'Pick color',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    trailing: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: selectedColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  state is LoadingUserTableState
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        )
                      : RaisedButton(
                          onPressed: () async {
                            final GroupLinkTableModel prevUserData =
                                GroupLinkTableModel.fromJson(
                                    widget.snapshot.data);

                            final LinkTypeModel type = LinkTypeModel(
                              importance: importanceValue,
                              name: _groupNameController.text,
                              color: selectedColor,
                            );

                            BlocProvider.of<GroupTableBloc>(context).add(
                              AddNewLinkTypeForGroupEvent(
                                type,
                                prevUserData,
                                widget.snapshot.reference,
                              ),
                            );
                          },
                          child: Text(
                            'Add',
                            style: Theme.of(context).textTheme.button,
                          ),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void changeImportance(int i) {
    closeKeyBoard();

    final newImportanceValue = importanceValue + i;

    if (newImportanceValue >= 0 && newImportanceValue <= 12) {
      setState(() {
        importanceValue = newImportanceValue;
      });
    }
  }

  void _openDialog(String title, Widget content) {
    closeKeyBoard();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            FlatButton(
              child: Text(
                'BACK',
              ),
              onPressed: Navigator.of(context).pop,
            ),
          ],
        );
      },
    );
  }

  void _openColorPicker() async {
    closeKeyBoard();

    _openDialog(
      'Color picker',
      CircleColorPicker(
        initialColor: Colors.red,
        onChanged: (color) {
          setState(() {
            selectedColor = color;
          });
        },
      ),
    );
  }

  void closeKeyBoard() {
    FocusScope.of(context).unfocus();
  }
}
