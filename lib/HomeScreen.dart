import 'package:flutter/material.dart';
import './FeedListView.dart';
import './FeedManager.dart';
import './Feed.dart';
import './NoFeed.dart';
import './HomeScreenDrawer.dart';
import './Settings.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  final String title = "Dragon Feed";

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    List<Feed> feeds = FeedManager.getPublicFeeds().toList();

    if(feeds.length == 0) {
      return _buildNoFeed();
    }else {
      if (Settings.showTabBarOnHomeScreen) {
        return _buildWithTabBar(feeds);
      } else {
        return _buildWithTabBar(feeds);
      }
    }
  }

  Widget _buildNoTabBar(List<Feed> feeds) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => FeedManager.syncAllFeeds(),
            )
          ],
        ),
        body: FeedListView(FeedManager.getCurrentFeed()),
        drawer: Drawer(child: HomeScreenDrawer()));
  }

  Widget _buildWithTabBar(List<Feed> feeds) {
    TabBar tabBar = TabBar(
      isScrollable: true,
      tabs: <Widget>[],
    );

    TabBarView body = TabBarView(
      children: <Widget>[],
    );

    for (Feed feed in feeds) {
      tabBar.tabs.add(Tab(text: feed.title));
      body.children.add(FeedListView(feed));
    }

    return DefaultTabController(
        length: feeds.length,
        child: Scaffold(
            appBar: new AppBar(
              title: new Text(widget.title),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () => FeedManager.syncAllFeeds(),
                )
              ],
              bottom: tabBar,
            ),
            body: body,
            drawer: Drawer(child: HomeScreenDrawer())));
  }

  Widget _buildNoFeed() {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => FeedManager.syncAllFeeds(),
            )
          ],
        ),
        body: NoFeed());
  }
}
