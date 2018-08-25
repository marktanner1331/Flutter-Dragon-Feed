import 'package:flutter/material.dart';

abstract class FeedItem {
  Map<String, dynamic> toJson();
  Widget getFeedItemTile();
}