import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/screens/feed/activity.dart';
import 'package:instagram/screens/feed/feed.dart';
import 'package:instagram/screens/feed/profile.dart';
import 'package:instagram/screens/feed/reels.dart';
import 'package:instagram/screens/feed/search.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key, required this.controller}) : super(key: key);
  final PageController controller;
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int currIndex = 0;
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: currIndex == 0 ? Feed(controller: widget.controller) :
      currIndex == 1 ? Search() :
      currIndex == 2 ? Reels() :
      currIndex == 3 ? Activity() :
                       Profile(me: true,),
      bottomNavigationBar: Container(
        height: deviceWidth * 0.18,
        child: BottomNavigationBar(
          selectedFontSize: 0,
          unselectedFontSize: 0,
          currentIndex: currIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: deviceWidth * 0.07,
          fixedColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              label: '',
              icon: IconButton(
                onPressed: () {
                  setState(() {
                    currIndex = 0;
                  });
                },
                alignment: Alignment.topCenter,
                icon: Image.asset(
                  currIndex == 0 ? 'assets/bottomicons/home1.png' :'assets/bottomicons/home.png',
                  height: deviceWidth * 0.07,
                  width: deviceWidth * 0.07,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: IconButton(
                onPressed: () {
                  setState(() {
                    currIndex = 1;
                  });
                },
                alignment: Alignment.center,
                icon: SvgPicture.asset(
                  currIndex == 1 ? 'assets/bottomicons/search1.svg' :'assets/bottomicons/search0.svg',
                  height: deviceWidth * 0.07,
                  width: deviceWidth * 0.07,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: IconButton(
                onPressed: () {
                  setState(() {
                    currIndex = 2;
                  });
                },
                alignment: Alignment.center,
                icon: Image.asset(
                  currIndex == 2 ? 'assets/bottomicons/reel1.png' :'assets/bottomicons/reel.png',
                  height: deviceWidth * 0.07,
                  width: deviceWidth * 0.07,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: IconButton(
                onPressed: () {
                  setState(() {
                    currIndex = 3;
                  });
                },
                alignment: Alignment.center,
                icon: SvgPicture.asset(
                  currIndex == 3 ? 'assets/bottomicons/heart2.svg' :'assets/bottomicons/heart0.svg',
                  height: deviceWidth * 0.07,
                  width: deviceWidth * 0.07,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: IconButton(
                onPressed: () {
                  setState(() {
                    currIndex = 4;
                  });
                },
                alignment: Alignment.center,
                icon: Stack(
                  alignment: Alignment.center,
                  children: [
                    // CircleAvatar(
                    //   radius: deviceWidth * 0.25,
                    //   backgroundColor: Colors.black,
                    // ),
                    CircleAvatar(
                      radius: deviceWidth * 0.10,
                      backgroundImage: const AssetImage('assets/avatar.png')
                    ),
                  ],
                ),
              ),
              ),
          ],
        ),
        ),
      );
  }
}
