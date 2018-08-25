import 'package:flutter/material.dart';
import './FeedManager.dart';
import './SplashScreen.dart';
import './HomeScreen.dart';
import './Feed.dart';
import './Settings.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  MyApp() {
    print("starting app");
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dragon Feed',
      theme: new ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/HomeScreen': (BuildContext context) => new HomeScreen()
      },
    );
  }
}