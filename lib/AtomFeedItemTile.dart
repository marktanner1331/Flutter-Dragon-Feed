import 'package:flutter/material.dart';
import "./AtomFeedItem.dart";
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class AtomFeedItemTile extends StatelessWidget {
  final AtomFeedItem feedItem;

  AtomFeedItemTile(this.feedItem);

  @override
  Widget build(BuildContext context) {
    if(feedItem.imageURL != null) {
      return GestureDetector(
          child: ListTile(
              leading: Image.network(feedItem.imageURL,
                  height: 64.0),
              title: Text(feedItem.title)
          ),
          onTap: () {
            launchWebView(context, feedItem.title, feedItem.url);
          });
    } else {
      return GestureDetector(
          child: ListTile(
              title: Text(feedItem.title)
          ),
          onTap: () {
            launchWebView(context, feedItem.title, feedItem.url);
          });
    }
  }

  void launchWebView(BuildContext context, String title, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return new WebviewScaffold(
            url: url,
            appBar: new AppBar(
              title: new Text(title),
            ),
          );
        },
      ),
    );
  }
}