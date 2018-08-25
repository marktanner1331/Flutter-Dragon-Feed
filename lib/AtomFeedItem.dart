import './FeedItem.dart';
import 'package:xml/xml.dart' as xml;
import "./AtomFeedItemTile.dart";
import 'package:flutter/material.dart';

class AtomFeedItem extends FeedItem {
  String title;
  String imageURL;
  String url;

  AtomFeedItem([this.title, this.imageURL, this.url]);

  Widget getFeedItemTile() => AtomFeedItemTile(this);

  factory AtomFeedItem.fromXML(xml.XmlElement node) {
    AtomFeedItem feedItem = new AtomFeedItem();

    try {
      feedItem.title = node
          .findElements('title')
          .single
          .text;
    } catch (e) {}

    try {
      feedItem.url = node
          .findElements('link')
          .single
          .attributes
          .firstWhere((attr) => attr.name.toString() == "href")
          .value;
    } catch (e) {}

    RegExp findImage = RegExp("<img[^>]+src=(?:\"|')(.*?)(?:\"|')");

    String htmlContent = node
        .findElements('content')
        .single
        .text;

    Match match = findImage.firstMatch(htmlContent);
    if(match != null) {
      feedItem.imageURL = match.group(1);
    } else {
      print("failed to find image url: $htmlContent");
    }

    return feedItem;
  }

  factory AtomFeedItem.fromJSON(Map<String, dynamic> json) {
    AtomFeedItem feedItem = new AtomFeedItem();
    feedItem.title = json["title"];
    feedItem.imageURL = json["imageURL"];
    feedItem.url = json["url"];

    return feedItem;
  }

  Map<String, dynamic> toJson() =>
      {
        'title': title,
        'imageURL': imageURL,
        'url': url,
        'type': 'atom'
      };
}