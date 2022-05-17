import 'package:flutter/material.dart';
import 'package:instagram/screens/camerascreen.dart';
import 'package:instagram/screens/dmscreen.dart';
import 'package:instagram/screens/feedscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key,required this.prefs}) : super(key: key);
  final SharedPreferences prefs;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = PageController(initialPage: 1);
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: [
          const CameraScreen(),
          FeedScreen(controller: _controller,),
          DmScreen(controller: _controller,),
        ],
      ),
    );
  }
}
