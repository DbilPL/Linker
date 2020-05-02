import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:linker/features/table/data/model/link_type_model.dart';
import 'package:linker/features/table/data/model/user_data_model.dart';
import 'package:linker/features/table/data/model/user_link_table_model.dart';
import 'package:linker/features/table/presentation/bloc/bloc.dart';
import 'package:linker/features/table/presentation/bloc/user_table_bloc.dart';
import 'package:linker/features/table/presentation/bloc/user_table_event.dart';

class AddLinkGroupPage extends StatefulWidget {
  final DocumentSnapshot snapshot;

  AddLinkGroupPage({Key key, this.snapshot}) : super(key: key);

  @override
  _AddLinkGroupPageState createState() => _AddLinkGroupPageState();
}

class _AddLinkGroupPageState extends State<AddLinkGroupPage> {
  TextEditingController _groupNameController = TextEditingController(text: '');
  int importanceValue = 0;
  Color selectedColor = Colors.red;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(builder: (context) {
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
              RaisedButton(
                onPressed: () async {
                  if (_groupNameController.text != '') {
                    bool isExist = false;
                    UserDataModel prevUserData =
                        UserDataModel.fromJson(widget.snapshot.data);

                    if (prevUserData.table == null) {
                      final prevUserData =
                          UserDataModel.fromJson(widget.snapshot.data);
                      final newUserData = UserDataModel(
                        name: prevUserData.name,
                        groupNameList: prevUserData.groupNameList,
                        table: UserLinkTableModel(
                          links: [],
                          types: []..add(
                              LinkTypeModel(
                                importance: importanceValue,
                                name: _groupNameController.text,
                                color: selectedColor,
                              ),
                            ),
                        ),
                      );
                      BlocProvider.of<UserTableBloc>(context).add(
                        UpdateUserDataEvent(
                          newUserData,
                          widget.snapshot.reference,
                        ),
                      );
                    } else {
                      final prevUserData =
                          UserDataModel.fromJson(widget.snapshot.data);

                      List<LinkTypeModel> types =
                          List.from(prevUserData.table.types);

                      if (types.length != 0) {
                        int number;

                        for (int i = 0; i < types.length; i++) {
                          final currentType = types[i];
                          final nextType =
                              i == types.length ? types[i] : types[i + 1];
                          if (currentType.importance >= importanceValue &&
                              nextType.importance <= importanceValue) {
                            number = i + 1;
                          } else if (currentType.importance <=
                              importanceValue) {
                            number = 0;
                          }
                          if (number != null) break;
                        }

                        types.forEach(
                          (element) {
                            if (element.name == _groupNameController.text) {
                              isExist = true;
                            }
                          },
                        );

                        if (!isExist) {
                          types.insert(
                            number,
                            LinkTypeModel(
                              importance: importanceValue,
                              name: _groupNameController.text,
                              color: selectedColor,
                            ),
                          );
                        } else {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'This group already exist!',
                              ),
                              backgroundColor: Theme.of(context).errorColor,
                            ),
                          );
                        }
                      } else {
                        types.add(
                          LinkTypeModel(
                            importance: importanceValue,
                            name: _groupNameController.text,
                            color: selectedColor,
                          ),
                        );
                      }

                      final newUserDataModel = UserDataModel(
                        groupNameList: prevUserData.groupNameList,
                        name: prevUserData.name,
                        table: UserLinkTableModel(
                          links: prevUserData.table.links,
                          types: types,
                        ),
                      );

                      BlocProvider.of<UserTableBloc>(context).add(
                        UpdateUserDataEvent(
                          newUserDataModel,
                          widget.snapshot.reference,
                        ),
                      );
                    }
                    if (!isExist) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text(
                  'Add',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void changeImportance(int i) {
    final newImportanceValue = importanceValue + i;

    if (newImportanceValue >= 0 && newImportanceValue <= 12) {
      setState(() {
        importanceValue = newImportanceValue;
      });
    }
  }

  void _openDialog(String title, Widget content) {
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
}
