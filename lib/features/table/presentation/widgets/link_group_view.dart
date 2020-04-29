import 'package:flutter/material.dart';
import 'package:linker/features/table/data/model/link_model.dart';
import 'package:linker/features/table/data/model/link_type_model.dart';

import 'link_view.dart';

class LinkGroupView extends StatefulWidget {
  final LinkTypeModel type;
  final List<LinkModel> links;

  LinkGroupView({Key key, this.type, this.links}) : super(key: key);

  @override
  _LinkGroupViewState createState() => _LinkGroupViewState();
}

class _LinkGroupViewState extends State<LinkGroupView> {
  bool isFullView = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      color: widget.type.color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_down),
                    onPressed: () {},
                  ),
                  Text(widget.type.name),
                ],
              ),
              trailing: Text('Importance: ${widget.type.importance}'),
            ),
          ]..addAll(
              isFullView
                  ? Iterable.generate(
                      3,
                      (index) => LinkView(
                        link: widget.links[index],
                      ),
                    )
                  : Iterable.generate(
                      widget.links.length,
                      (index) => LinkView(
                        link: widget.links[index],
                      ),
                    ),
            ),
        ),
      ),
    );
  }
}
