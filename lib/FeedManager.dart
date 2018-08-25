import 'dart:async';
import './Feed.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import "./RSSFeed.dart";

typedef void callback();

class FeedManager {
  static List<Feed> _feeds = new List<Feed>();

  static Future initialize() async {
    await _initializeFeedsFromFile();

    addFeed(RSSFeed.newFeed(
        feedURL: "http://feeds.bbci.co.uk/news/rss.xml",
        updateFrequency: Duration(hours: 1)));
    addFeed(RSSFeed.newFeed(
        feedURL: "https://www.reddit.com/r/PrettyGirls/.rss",
        updateFrequency: Duration(hours: 1)));
  }

  static Feed getCurrentFeed() {
    return _feeds.first;
  }

  static Iterable<Feed> getPublicFeeds() {
    return _feeds.where((feed) => feed.isPublic);
  }

  static bool addFeed(Feed feed) {
    //if(_feeds.indexWhere((existingFeed) => existingFeed.compareTo(feed) == 0) > -1) {
    if (_feeds.contains(feed)) {
      print("feed already added");
      return false;
    }

    _feeds.add(feed);
    _saveFeedListToFile();

    return true;
  }

  static Future _initializeFeedsFromFile() async {
    final directory = await getApplicationDocumentsDirectory();

    if (FileSystemEntity.typeSync(directory.path + "/feedList.json") ==
        FileSystemEntityType.notFound) {
      return;
    }

    final file = File(directory.path + "/feedList.json");

    String contents = await file.readAsString();
    print(contents);
    for (Map<String, dynamic> feedJSON in json.decode(contents)["feeds"]) {
      Feed feed = Feed.fromJSON(feedJSON);
      _feeds.add(feed);
    }

    await Future.wait(_feeds.map((feed) => feed.loadItemsFromDisc()));
  }

  static Future _saveFeedListToFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(directory.path + "/feedList.json");

    String jsonString = json.encode({"feeds": _feeds});

    await file.writeAsString(jsonString);
  }

  static void syncAllFeeds() async {
    await Future.wait(_feeds.map((feed) => feed.syncFeed()));
    await _saveFeedListToFile();
    print("synced from syncAllFeeds");
  }
}
