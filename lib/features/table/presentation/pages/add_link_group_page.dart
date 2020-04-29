import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:linker/features/table/data/model/link_type_model.dart';
import 'package:linker/features/table/data/model/user_data_model.dart';
import 'package:linker/features/table/presentation/bloc/user_table_bloc.dart';
import 'package:linker/features/table/presentation/bloc/user_table_event.dart';

class AddLinkGroupPage extends StatefulWidget {
  AddLinkGroupPage({Key key}) : super(key: key);

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
      body: Padding(
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
              title: GestureDetector(
                onTap: () {
                  _openColorPicker();
                },
                child: Text(
                  'Pick color',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
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
                  final prevStream =
                      BlocProvider.of<UserTableBloc>(context).state.stream;
                  final lastState = await prevStream.last;

                  final newUserData = UserDataModel.fromJson(lastState.data)
                    ..table.types.add(
                          LinkTypeModel(
                            importance: importanceValue,
                            name: _groupNameController.text,
                            color: selectedColor,
                          ),
                        );

                  BlocProvider.of<UserTableBloc>(context).add(
                    UpdateUserDataEvent(
                      newUserData,
                      lastState.reference,
                      prevStream,
                    ),
                  );

                  Navigator.pop(context);
                }
              },
              child: Text(
                'Add',
                style: Theme.of(context).textTheme.button,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeImportance(int i) {
    final newImportanceValue = importanceValue + i;

    if (newImportanceValue >= 0) {
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
      "Color picker",
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
