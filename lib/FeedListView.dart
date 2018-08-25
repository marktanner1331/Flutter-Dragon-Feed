import 'package:flutter/material.dart';
import './Feed.dart';
import './FeedItem.dart';
import 'dart:async';

class FeedListView extends StatefulWidget {
  final Feed feed;

  FeedListView(this.feed);

  @override
  _FeedListState createState() => new _FeedListState();
}

class _FeedListState extends State<FeedListView> {
  StreamSubscription _updateListener;

  @override
  void initState() {
    super.initState();

    _updateListener = widget.feed.listenForUpdates(() => setState(() { }));
  }

  @override
  void dispose() {
    super.dispose();

    _updateListener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    List<FeedItem> items = widget.feed.items;
    print("building feed list");
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          if (index % 2 == 0) {
            return items[index ~/ 2].getFeedItemTile();
          } else {
            return Divider(height: 10.0);
          }
        },
        itemCount: items.length * 2 - 1);
  }
}