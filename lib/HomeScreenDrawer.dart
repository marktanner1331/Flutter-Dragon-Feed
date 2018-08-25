import 'package:flutter/material.dart';
import './ListTileHeader.dart';
import './FeedManager.dart';
import './Feed.dart';

class HomeScreenDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> children = new List<Widget>();

    children.add(ListTileHeader(
      title: new Text("Feeds"),
      color: Colors.grey,
      topPadding: 25.0,
    ));

    List<Feed> feeds = FeedManager.getPublicFeeds().toList();
    for (Feed feed in feeds) {
      children.add(ListTile(title: Text(feed.title)));
    }

    children.add(ListTileHeader(
      title: new Text("Settings"),
      color: Colors.grey,
    ));

    children.add(ListTile(
      title: new Text("Manage Feeds"),
    ));

    children.add(ListTile(
      title: new Text("App Settings"),
    ));

    children.add(AboutListTile());

    return ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: children // We'll populate the Drawer in the next step!
        );
  }
}
