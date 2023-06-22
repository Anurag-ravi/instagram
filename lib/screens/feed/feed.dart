import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/components/postcard.dart';
import 'package:instagram/components/storycard.dart';
import 'package:instagram/models/postmodel.dart';
import 'package:instagram/models/story_model.dart';
import 'package:instagram/models/user_model.dart';
import 'package:instagram/screens/posts/postcreate.dart';
import 'package:instagram/utilities/constants.dart';
import 'package:instagram/utilities/logout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class Feed extends StatefulWidget {
  const Feed({Key? key, required this.controller,required this.prefs}) : super(key: key);
  final PageController controller;
  final SharedPreferences prefs;
  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  List<PostModel> posts = [];
  List<StoryModel> stories = [];
  List<Story> my_story = [];
  int pagecount = 0;
  late ScrollController _scrollController;
  bool isFetching = false;
  double prevPageScroll = 0.0;

  


  Future<void> fetchposts() async {
      String? token = widget.prefs.getString('token');
      String? url = widget.prefs.getString('url');
      final response = await http.get(Uri.parse("${url!}feed/${pagecount}/"),
          headers: <String, String>{'Authorization': token!},);
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        if(pagecount == 0){
          setState(() {
            posts = (data as List).map((e) => PostModel.fromJson(e)).toList();
          });
        }else{
          setState(() {
            posts.addAll((data as List).map((e) => PostModel.fromJson(e)).toList());
          });
        }
        settoken(response);
        return;
      }
      if (response.statusCode == 401) {
        logout(context);
        return;
      }
      const snackBar = SnackBar(
      content: Text('Some Error occured 🥲'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  Future<void> fetchstories() async {
      String? token = widget.prefs.getString('token');
      String? url = widget.prefs.getString('url');
      final response = await http.get(Uri.parse("${url!}stories/all/"),
          headers: <String, String>{'Authorization': token!},);
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
          setState(() {
            stories = (data as List).map((e) => StoryModel.fromJson(e)).toList();
          });
        settoken(response);
        return;
      }
      if (response.statusCode == 401) {
        logout(context);
        return;
      }
      const snackBar = SnackBar(
      content: Text('Some Error occured 🥲'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  Future<void> fetchmystories() async {
      String? token = widget.prefs.getString('token');
      String? url = widget.prefs.getString('url');
      final response = await http.get(Uri.parse("${url!}stories/me/"),
          headers: <String, String>{'Authorization': token!},);
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
          setState(() {
             my_story = (data as List).map((e) => Story.fromJson(e)).toList();
          });
        settoken(response);
        return;
      } 
      if (response.statusCode == 401) {
        logout(context);
        return;
      }
      const snackBar = SnackBar(
      content: Text('Some Error occured 🥲'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _setupScrollController() {
    _scrollController = ScrollController();

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (!isFetching &&
      _scrollController.offset >= (_scrollController.position.maxScrollExtent - prevPageScroll) * 0.8 + prevPageScroll &&
      _scrollController.position.maxScrollExtent > 0) {
    setState(() {
      pagecount = pagecount + 1;
      prevPageScroll = _scrollController.position.maxScrollExtent;
    });
    
    setState(() {
      isFetching = true;
    });
    
    fetchposts().then((_) {
      setState(() {
        isFetching = false;
      });
    });
  }
  }

  Future<void> refresh() async {
    setState(() {
      pagecount = 0;
      posts = [];
    });
    await fetchposts();
    await fetchmystories();
    await fetchstories();
  }

  @override
  void initState() {
    // TODO: implement initState
    _setupScrollController();
    fetchposts();
    fetchstories();
    fetchmystories();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      onRefresh: refresh,
      child: Scaffold(
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
                    height: deviceWidth * 0.09)),
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
                        child: Text('3',
                            style: TextStyle(
                                fontSize: deviceWidth * 0.035,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        backgroundColor: Colors.red,
                      ),
                    )
                  ],
                )),
          ],
        ),
        body: Builder(
                builder: (context) {
                  if (posts.isEmpty) {
                    return const Center(
                      child: Text('Follow people to populate feed'),
                    );
                  }
    
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: posts.length + 4,
                    itemBuilder: (BuildContext context, int index) {
                      if(index == 0){
                        return const Divider(
                          height: 1,
                          thickness: 1,
                        );
                      }
                      if(index == 1){
                        return Container(
              height: deviceWidth * 0.32,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  stories.length + 1,
                  (int index) {
                    if(index==0) {
                      return StoryCard(story: StoryModel(my_story,User("My Story",widget.prefs.getString('dp')!)),prefs: widget.prefs,);}
                    return StoryCard(story: stories[index-1],prefs: widget.prefs,);
                  },
                ),
              ),
            );
                      }
                      if(index == 2){
                        return const Divider(
              height: 5,
              thickness: 1,
            );
                      }
                      if (index == posts.length + 3) {
                        return ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircularProgressIndicator(color: secondaryColor(context),),
                            ],
                          ),
                        );
                      } else {
                        return PostCard(post: posts[index-3], prefs: widget.prefs);
                      }
                    },
                  );
                },
              ),
      ),
    );
  }
}

void bottompopup1(context) {
  double devicewidth = MediaQuery.of(context).size.width;
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          height: devicewidth,
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
                        borderRadius: BorderRadius.circular(2)),
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
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>PostCreate()));
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  child: Row(
                    children: [
                      SizedBox(
                        width: devicewidth * 0.05,
                      ),
                      Icon(
                        Icons.view_module_outlined,
                        size: devicewidth * 0.07,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        width: devicewidth * 0.03,
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
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: Row(
                  children: [
                    SizedBox(
                      width: devicewidth * 0.05,
                    ),
                    Icon(
                      Icons.video_collection_outlined,
                      size: devicewidth * 0.07,
                      color: Colors.grey[300],
                    ),
                    SizedBox(
                      width: devicewidth * 0.03,
                    ),
                    Text(
                      'Reels',
                      style: TextStyle(
                        fontSize: devicewidth * 0.055,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: Row(
                  children: [
                    SizedBox(
                      width: devicewidth * 0.05,
                    ),
                    Icon(
                      Icons.add_circle_outline_rounded,
                      size: devicewidth * 0.07,
                      color: Colors.grey[300],
                    ),
                    SizedBox(
                      width: devicewidth * 0.03,
                    ),
                    Text(
                      'Story',
                      style: TextStyle(
                        fontSize: devicewidth * 0.055,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: Row(
                  children: [
                    SizedBox(
                      width: devicewidth * 0.05,
                    ),
                    Icon(
                      Icons.favorite_outline_rounded,
                      size: devicewidth * 0.07,
                      color: Colors.grey[300],
                    ),
                    SizedBox(
                      width: devicewidth * 0.03,
                    ),
                    Text(
                      'Story Highlight',
                      style: TextStyle(
                        fontSize: devicewidth * 0.055,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: Row(
                  children: [
                    SizedBox(
                      width: devicewidth * 0.05,
                    ),
                    Icon(
                      Icons.wifi_tethering,
                      size: devicewidth * 0.07,
                      color: Colors.grey[300],
                    ),
                    SizedBox(
                      width: devicewidth * 0.03,
                    ),
                    Text(
                      'Live',
                      style: TextStyle(
                        fontSize: devicewidth * 0.055,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
}

