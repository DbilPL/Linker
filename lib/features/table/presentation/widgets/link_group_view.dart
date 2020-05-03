import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linker/features/table/data/model/link_model.dart';
import 'package:linker/features/table/data/model/link_type_model.dart';
import 'package:linker/features/table/data/model/user_data_model.dart';
import 'package:linker/features/table/presentation/bloc/bloc.dart';
import 'package:linker/features/table/presentation/pages/add_link_page.dart';

import 'link_view.dart';

class LinkGroupView extends StatefulWidget {
  final LinkTypeModel type;
  final List<LinkModel> links;
  final DocumentSnapshot snapshot;
  final bool isEditing;

  LinkGroupView({
    Key key,
    this.type,
    this.links,
    this.snapshot,
    this.isEditing,
  }) : super(key: key);

  @override
  _LinkGroupViewState createState() => _LinkGroupViewState();
}

class _LinkGroupViewState extends State<LinkGroupView> {
  bool isFullView = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        width: double.infinity,
        color: widget.type.color,
        child: Column(
          children: [
            ListTile(
              title: Row(
                children: [
                  Text(widget.type.importance.toString()),
                  widget.isEditing
                      ? SizedBox(
                          width: 15,
                        )
                      : TweenAnimationBuilder(
                          duration: Duration(milliseconds: 150),
                          tween: Tween<double>(
                            begin: isFullView ? -(pi / 2) : 0,
                            end: isFullView ? 0 : -(pi / 2),
                          ),
                          builder: (context, integer, child) {
                            return Transform.rotate(
                              angle: integer,
                              child: child,
                            );
                          },
                          child: IconButton(
                            icon: Icon(Icons.keyboard_arrow_down),
                            onPressed: () {
                              setState(() {
                                isFullView = !isFullView;
                              });
                            },
                          ),
                        ),
                  Text('"${widget.type.name}" links'),
                ],
              ),
              trailing: IconButton(
                icon: widget.isEditing
                    ? Icon(Icons.delete_forever)
                    : Icon(Icons.add),
                onPressed: () {
                  if (!widget.isEditing) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddLinkPage(
                          snapshot: widget.snapshot,
                          type: widget.type,
                        ),
                      ),
                    );
                  } else {
                    final prevUserDataModel =
                        UserDataModel.fromJson(widget.snapshot.data);

                    BlocProvider.of<UserTableBloc>(context).add(
                      DeleteLinkType(
                        widget.type,
                        prevUserDataModel,
                        widget.snapshot.reference,
                      ),
                    );
                  }
                },
              ),
            ),
          ]..addAll(
              widget.links.length != 0
                  ? widget.isEditing
                      ? Iterable.generate(
                          widget.links.length,
                          (index) => Dismissible(
                            onDismissed: (direction) {},
                            direction: DismissDirection.startToEnd,
                            background: Container(
                              color: Colors.redAccent,
                            ),
                            key: Key(index.toString()),
                            child: LinkView(
                              link: widget.links[index],
                            ),
                          ),
                        )
                      : !isFullView
                          ? Iterable.generate(
                              widget.links.length < 4 ? widget.links.length : 3,
                              (index) => LinkView(
                                link: widget.links[index],
                              ),
                            )
                          : Iterable.generate(
                              widget.links.length,
                              (index) => LinkView(
                                link: widget.links[index],
                              ),
                            )
                  : [
                      Text(
                        'No links!',
                      ),
                      SizedBox(
                        height: 12,
                      ),
                    ],
            ),
        ),
      ),
    );
  }
}
