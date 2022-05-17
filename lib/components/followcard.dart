import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:instagram/components/cacheimage.dart';
import 'package:instagram/models/suggestionmodel.dart';
import 'package:instagram/utilities/constants.dart';
import 'package:instagram/utilities/logout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../data.dart';

class FollowCard extends StatefulWidget {
  const FollowCard({ Key? key,required this.profile }) : super(key: key);
  final SuggestionModel profile;
  @override
  State<FollowCard> createState() => _FollowCardState();
}

class _FollowCardState extends State<FollowCard> {

  Future<void> follow() async {
      SharedPreferences prefs =
      await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.post(Uri.parse("${url}user/follow/"),
          headers: <String, String>{'Authorization': token!},
          body: jsonEncode({"username": widget.profile.username}));
      if (response.statusCode == 200) {
        setState(() {
          widget.profile.following = !widget.profile.following;
        });
        settoken(response);
        return;
      }
      if (response.statusCode == 401) {
        logout(context);
        return;
      }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(5),
      width: deviceWidth * 0.45,
      height: deviceWidth * 0.6,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54, width: deviceWidth * 0.002),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: deviceWidth * 0.24,
            height: deviceWidth * 0.24,
            margin: const EdgeInsets.all(5),
            child: ClipOval(
              child: Container(
                width: deviceWidth * 0.24,
                height: deviceWidth * 0.24,
                child: widget.profile.dp != ''
                    ? ChachedImage(url: widget.profile.dp)
                    : Image.asset('assets/avatar.png'),
              ),
            ),
          ),
          Flexible(
            child: Text(
              widget.profile.username,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: deviceWidth * 0.045),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Flexible(
            child: Text(
              widget.profile.followedBy == '' ? widget.profile.name : 'followed by ${widget.profile.followedBy}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: deviceWidth * 0.04),
              overflow: TextOverflow.visible,
            ),
          ),
          GestureDetector(
            onTap: () {
              follow();
            },
            child: Container(
            height: deviceWidth * 0.085,
            width: deviceWidth * 0.4,
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)), 
              color: widget.profile.following ? Colors.transparent : Colors.blue,
              border: widget.profile.following ? Border.all(color:secondaryColor(context),width: 0) : null
            ),
            child: Center(
              child: Text(
                widget.profile.following ? 'Following'  : widget.profile.followsMe ? 'Follows You' : 'Follow',
                style: TextStyle(
                  color: widget.profile.following ? secondaryColor(context) : primaryColor(context),
                  fontSize: deviceWidth * 0.04,
                  fontWeight: FontWeight.w600,
                ),
                ),
            ),
          )
          ),
        ],
      ),
    );
  }
}
