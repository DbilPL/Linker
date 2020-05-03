import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linker/features/table/data/model/link_model.dart';
import 'package:linker/features/table/data/model/link_type_model.dart';
import 'package:linker/features/table/presentation/pages/add_link_page.dart';

import 'link_view.dart';

class LinkGroupView extends StatefulWidget {
  final LinkTypeModel type;
  final List<LinkModel> links;
  final DocumentSnapshot snapshot;

  LinkGroupView({Key key, this.type, this.links, this.snapshot})
      : super(key: key);

  @override
  _LinkGroupViewState createState() => _LinkGroupViewState();
}

class _LinkGroupViewState extends State<LinkGroupView> {
  bool isFullView = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        width: size.width,
        color: widget.type.color,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Row(
                  children: [
                    Text(widget.type.importance.toString()),
                    TweenAnimationBuilder(
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
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddLinkPage(
                          snapshot: widget.snapshot,
                          type: widget.type,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ]..addAll(
                widget.links.length != 0
                    ? !isFullView
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
                      ],
              ),
          ),
        ),
      ),
    );
  }
}
