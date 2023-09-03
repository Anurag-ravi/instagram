
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/components/cacheimage.dart';
import 'package:instagram/screens/feedscreen.dart';
import 'package:instagram/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavTemp extends StatefulWidget {
  const BottomNavTemp({ Key? key }) : super(key: key);

  @override
  State<BottomNavTemp> createState() => _BottomNavTempState();
}

class _BottomNavTempState extends State<BottomNavTemp> {
  final _controller = PageController(initialPage: 1);
  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  init() async {
    SharedPreferences temp = await SharedPreferences.getInstance();
    setState(() {
      prefs = temp;
    });
  }
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
        height: deviceWidth * 0.18,
        child: BottomNavigationBar(
          selectedFontSize: 0,
          unselectedFontSize: 0,
          currentIndex: 4,
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
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>FeedScreen(controller: _controller,tab: 0,prefs: prefs,)));
                },
                alignment: Alignment.topCenter,
                icon: Image.asset(
                  'assets/bottomicons/home.png',
                  height: deviceWidth * 0.07,
                  width: deviceWidth * 0.07,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>FeedScreen(controller: _controller,tab: 1,prefs: prefs)));
                },
                alignment: Alignment.center,
                icon: SvgPicture.asset(
                  'assets/bottomicons/search0.svg',
                  height: deviceWidth * 0.07,
                  width: deviceWidth * 0.07,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>FeedScreen(controller: _controller,tab: 2,prefs: prefs)));
                },
                alignment: Alignment.center,
                icon: Image.asset(
                  'assets/bottomicons/reel.png',
                  height: deviceWidth * 0.07,
                  width: deviceWidth * 0.07,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>FeedScreen(controller: _controller,tab: 3,prefs: prefs)));
                },
                alignment: Alignment.center,
                icon: SvgPicture.asset(
                  'assets/bottomicons/heart0.svg',
                  height: deviceWidth * 0.07,
                  width: deviceWidth * 0.07,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>FeedScreen(controller: _controller,tab: 4,prefs: prefs)));
                },
                alignment: Alignment.center,
                icon: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: deviceWidth * 0.12,
                      backgroundColor: secondaryColor(context)
                    ),
                    ClipOval(
                      child: Container(
                        width: deviceWidth*0.075,
                        height: deviceWidth*0.075,
                        child: ChachedImage(url: prefs.getString('dp')!,prefs: prefs,),
                      ),
                    ),
                  ],
                ),
              ),
              ),
          ],
        ),
        );
  }
}