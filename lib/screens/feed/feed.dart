import 'package:flutter/material.dart';
import 'package:instagram/components/postcard.dart';
import 'package:instagram/components/storycard.dart';

class Feed extends StatefulWidget {
  const Feed({ Key? key,required this.controller }) : super(key: key);
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
        centerTitle: true,
        title: SizedBox(
          height: deviceWidth * 0.12,
          child: Image.asset("assets/instagram_logo.png"),
        ),
        leading: IconButton(
          onPressed: () {
            widget.controller.animateToPage(0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          },
          alignment: Alignment.centerLeft,
          icon: Icon(
            Icons.camera_alt_outlined,
            color: Colors.black,
            size: deviceWidth * 0.08,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              widget.controller.animateToPage(2,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            },
            alignment: Alignment.center,
            icon: Image.asset(
              'assets/sending.png',
              height: deviceWidth * 0.06,
              width: deviceWidth * 0.06,
            ),
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