import 'package:xml/xml.dart' as xml;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import './Feed.dart';
import "./RSSFeedItem.dart";
import "./AtomFeedItem.dart";
import "./FeedItem.dart";

class RSSFeed extends Feed {
  final String feedURL;

  RSSFeed(
      {@required this.feedURL,
      @required Duration updateFrequency,
      @required uniqueID,
      String feedName,
      String preferredFeedName,
      bool isPublic})
      : super(
            uniqueID: uniqueID,
            updateFrequency: updateFrequency,
            isPublic: isPublic,
            feedName: feedName,
            preferredFeedName: preferredFeedName) {
    if(this.feedURL.contains("bbc")) {
      super.title = "BBC News";
    } else {
      super.title = "Reddit";
    }
  }

  factory RSSFeed.newFeed(
          {@required String feedURL,
          @required Duration updateFrequency,
          bool isPublic}) =>
      RSSFeed(
          feedURL: feedURL,
          updateFrequency: updateFrequency,
          uniqueID: Feed.getNewUniqueFeedID(),
          isPublic: isPublic);

  factory RSSFeed.fromJSON(Map<String, dynamic> feedJSON) => RSSFeed(
      feedURL: feedJSON["feedURL"],
      updateFrequency: Duration(seconds: feedJSON["updateFrequency"]),
      uniqueID: feedJSON["uniqueID"],
      isPublic: feedJSON["isPublic"],
      feedName: feedJSON["name"],
      preferredFeedName: feedJSON["preferredName"]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json["feedURL"] = feedURL;

    return json;
  }

  FeedItem getFeedItemFromJSON(Map<String, dynamic> json) {
    switch (json["type"]) {
      case "RSS":
        return RSSFeedItem.fromJSON(json);
      case "atom":
        return AtomFeedItem.fromJSON(json);
      default:
        throw new Exception("unknown item type: ${json["type"]}");
    }
  }

  bool operator ==(o) => o is RSSFeed && feedURL == o.feedURL;
  int get hashCode => feedURL.hashCode;

  Future syncFeed() async {
    print("syncing RSS Feed $feedURL");
    http.Response response = await http.get(feedURL);

    if (response.statusCode >= 200 && response.statusCode <= 400) {
      xml.XmlDocument document = xml.parse(response.body);

      switch (document.rootElement.name.toString()) {
        case "rss":
          parseRSSFeed(document);
          break;
        case "feed":
          parseAtomFeed(document);
          break;
        default:
          throw new Exception(
              "unknown feed type ${document.rootElement.name.toString()}");
      }

      print("finished syncing $feedURL");

      await super.syncFeed();
    } else {
      //handle error
    }
  }

  void parseRSSFeed(xml.XmlDocument document) {
    xml.XmlElement channelElement =
        document.rootElement.findElements('channel').single;

    preferredTitle = channelElement.findElements("title").single.text;

    //only setting this once so that the user can change it to something they way
    //and it wont be set back when we sync
    if (this.title == Feed.defaultFeedName) {
      this.title = preferredTitle;
    }

    items = channelElement
        .findElements('item')
        .map((itemElement) => new RSSFeedItem.fromXML(itemElement))
        .toList();
  }

  void parseAtomFeed(xml.XmlDocument document) {
    xml.XmlElement feedElement = document.rootElement;

    preferredTitle = feedElement.findElements("title").single.text;

    //only setting this once so that the user can change it to something they way
    //and it wont be set back when we sync
    if (this.title == Feed.defaultFeedName) {
      this.title = preferredTitle;
    }

    items = feedElement
        .findElements('entry')
        .map((itemElement) => new AtomFeedItem.fromXML(itemElement))
        .toList();
  }
}
