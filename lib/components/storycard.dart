import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram/components/story-view.dart';
import 'package:instagram/models/story_model.dart';
import 'package:instagram/utilities/demo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoryCard extends StatelessWidget {
  const StoryCard({Key? key,required this.story,required this.prefs}) : super(key: key);
  final StoryModel story;
  final SharedPreferences prefs;
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(9),
          child: GestureDetector(
            child: Stack(
              alignment: const Alignment(0, 0),
              children: <Widget>[
                Container(
                  width: deviceWidth * 0.224,
                  height: deviceWidth * 0.224,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Colors.purpleAccent, Colors.orange])),
                ),
                Container(
                  width: deviceWidth * 0.21,
                  height: deviceWidth * 0.21,
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                  ),
                ),
                Container(
                  width: deviceWidth * 0.195,
                  height: deviceWidth * 0.195,
                  child: CircleAvatar(
                      backgroundImage:user.profileImageUrl != '' ? CachedNetworkImageProvider( prefs.getString('media')! + story.user.profileImageUrl)
                        : Image.asset("assets/avatar.png").image,
                )),
                FloatingActionButton(
                  onPressed: () {
                    if(story.stories.length!=0)
                    Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (builder) => StoryScreen(stories: story.stories,user: story.user,prefs: prefs,)));
                  },
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              ],
            ),
          ),
        ),
        Text(
          story.user.name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: deviceWidth * 0.03),
        ),
      ],
    );
  }
}
