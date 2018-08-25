import 'package:flutter/material.dart';

class ListTileHeader extends StatelessWidget {
  final Widget title;
  final Color color;
  final double topPadding;

  ListTileHeader({this.title, this.color, double topPadding})
      : topPadding = topPadding ?? 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: topPadding),
      child: ListTile(
        title: title,
      ),
      color: color,
    );
  }
}
