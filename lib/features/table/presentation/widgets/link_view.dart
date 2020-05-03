import 'package:flutter/material.dart';
import 'package:linker/features/table/data/model/link_model.dart';
import 'package:share/share.dart';

class LinkView extends StatefulWidget {
  final LinkModel link;

  LinkView({Key key, this.link}) : super(key: key);

  @override
  _LinkViewState createState() => _LinkViewState();
}

class _LinkViewState extends State<LinkView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.link.title),
            Text(widget.link.link),
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share(widget.link.link);
              },
            ),
          ],
        ),
      ),
    );
  }
}
