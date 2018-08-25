import 'package:flutter/material.dart';
import './feed.dart';

class FeedSettingsView extends StatefulWidget {
  final Feed feed;

  FeedSettingsView(this.feed);

  @override
  _FeedSettingsViewState createState() => new _FeedSettingsViewState();
}

class _FeedSettingsViewState extends State<FeedSettingsView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.feed.uniqueID),
    );
  }
}