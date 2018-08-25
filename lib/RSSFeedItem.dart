import './FeedItem.dart';
import 'package:xml/xml.dart' as xml;
import "./RSSFeedItemTile.dart";
import 'package:flutter/material.dart';

class RSSFeedItem extends FeedItem {
  String title;
  String description;
  String imageURL;
  String url;

  RSSFeedItem([this.title, this.description, this.imageURL, this.url]);

  Widget getFeedItemTile() => RSSFeedItemTile(this);

  factory RSSFeedItem.fromXML(xml.XmlElement node) {
    RSSFeedItem feedItem = new RSSFeedItem();

    try {
      feedItem.title = node
          .findElements('title')
          .single
          .text;
    } catch (e) {}

    try {
      feedItem.description = node
          .findElements('description')
          .single
          .text;
    } catch (e) {}

    try {
      feedItem.url = node
          .findElements('link')
          .single
          .text;
    } catch (e) {}

    try {
      feedItem.imageURL = node
          .findElements('media:thumbnail')
          .single
          .attributes
          .firstWhere((attr) => attr.name.toString() == "url")
          .value;
    } catch (e) {}

    return feedItem;
  }

  factory RSSFeedItem.fromJSON(Map<String, dynamic> json) {
    RSSFeedItem feedItem = new RSSFeedItem();
    feedItem.title = json["title"];
    feedItem.imageURL = json["imageURL"];
    feedItem.description = json["description"];
    feedItem.url = json["url"];

    return feedItem;
  }

  Map<String, dynamic> toJson() =>
      {
        'title': title,
        'description': description,
        'imageURL': imageURL,
        'url': url,
        'type': 'RSS'
      };
}