import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/components/postcard.dart';
import 'package:instagram/components/storycard.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key, required this.controller}) : super(key: key);
  final PageController controller;
  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff8faf8),
        elevation: 0.0,
        title: SizedBox(
          height: deviceWidth * 0.12,
          child: Image.asset("assets/instagram_logo.png"),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                bottompopup1(context);
               },
              alignment: Alignment.center,
              icon: SvgPicture.asset('assets/add.svg',
                  height: deviceWidth * 0.09)
              ),
          IconButton(
              onPressed: () {
                widget.controller.animateToPage(2,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              },
              alignment: Alignment.center,
              icon: Stack(
                children: [
                  SvgPicture.asset('assets/messenger.svg',
                      height: deviceWidth * 0.08),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: deviceWidth * 0.025,
                      child: Text('3',style: TextStyle(fontSize: deviceWidth * 0.035,fontWeight: FontWeight.w600,color: Colors.white)),
                      backgroundColor: Colors.red,
                    ),
                  )
                ],
              )
              ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              const Divider(
                height: 1,
                thickness: 1,
              ),
              Container(
                height: deviceWidth * 0.32,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    10,
                    (int index) {
                      return const StoryCard();
                    },
                  ),
                ),
              ),
              const Divider(
                height: 5,
                thickness: 1,
              )
            ]),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              List.generate(
                17,
                (int index) {
                  return PostCard();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void bottompopup1(context) {
  double devicewidth = MediaQuery.of(context).size.width;
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          height: devicewidth,
          child: Flexible(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Center(
                    child: Container(
                      width: devicewidth * 0.15,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(2)
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Center(
                    child: Text(
                        'Create',
                        style: TextStyle(
                          fontSize: devicewidth * 0.06,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                  ),
                ),
                const Divider(
                  height: 5,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: devicewidth * 0.05,
                      ),
                      Icon(
                        Icons.grid_3x3_rounded,
                        size: devicewidth * 0.07,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        width: devicewidth * 0.02,
                      ),
                      Text(
                        'Post',
                        style: TextStyle(
                          fontSize: devicewidth * 0.055,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: devicewidth * 0.05,
                      ),
                      Icon(
                        Icons.video_collection_outlined,
                        size: devicewidth * 0.07,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        width: devicewidth * 0.02,
                      ),
                      Text(
                        'Reels',
                        style: TextStyle(
                          fontSize: devicewidth * 0.055,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: devicewidth * 0.05,
                      ),
                      Icon(
                        Icons.add_circle_outline_rounded,
                        size: devicewidth * 0.07,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        width: devicewidth * 0.02,
                      ),
                      Text(
                        'Story',
                        style: TextStyle(
                          fontSize: devicewidth * 0.055,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: devicewidth * 0.05,
                      ),
                      Icon(
                        Icons.favorite_outline_rounded,
                        size: devicewidth * 0.07,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        width: devicewidth * 0.02,
                      ),
                      Text(
                        'Story Highlight',
                        style: TextStyle(
                          fontSize: devicewidth * 0.055,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: devicewidth * 0.05,
                      ),
                      Icon(
                        Icons.wifi_tethering,
                        size: devicewidth * 0.07,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        width: devicewidth * 0.02,
                      ),
                      Text(
                        'Live',
                        style: TextStyle(
                          fontSize: devicewidth * 0.055,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
