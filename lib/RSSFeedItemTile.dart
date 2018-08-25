import 'package:flutter/material.dart';
import "./RSSFeedItem.dart";
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class RSSFeedItemTile extends StatelessWidget {
  final RSSFeedItem feedItem;

  RSSFeedItemTile(this.feedItem);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: ListTile(
            leading: Image.network(feedItem.imageURL,
                height: 64.0),
            title: Text(feedItem.title)
        ),
        onTap: () {
          launchWebView(context, feedItem.title, feedItem.url);
        });
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