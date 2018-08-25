import 'package:flutter/material.dart';
import './FeedManager.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    FeedManager.initialize().then((_) {
      Navigator.of(context).pushReplacementNamed('/HomeScreen');
    });

    return new Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}