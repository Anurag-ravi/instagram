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
              onPressed: () { },
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
