// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:instagram/components/cacheimage.dart';
import 'package:instagram/data.dart';
import 'package:instagram/models/followmodel.dart';
import 'package:instagram/screens/feed/profile.dart';
import 'package:instagram/utilities/constants.dart';
import 'package:instagram/utilities/logout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileCard extends StatefulWidget {
  const ProfileCard({ Key? key,required this.profile }) : super(key: key);
  final FollowModel profile;
  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  

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
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (builder)=> Profile(me: false,username: widget.profile.username)));
      },
        leading: ClipOval(
          child: Container(
            width: deviceWidth * 0.14,
            height: deviceWidth * 0.14,
            child: widget.profile.dp != ''
                ? ChachedImage(url: widget.profile.dp)
                : Image.asset('assets/avatar.png'),
          ),
        ),
        title: Text(
          widget.profile.username,
          style: TextStyle(fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(widget.profile.name,overflow: TextOverflow.ellipsis,),
        trailing: GestureDetector(
          onTap: () {
            follow();
          },
          child: Container(
            height: deviceWidth * 0.085,
            width: deviceWidth * 0.345,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)), 
              color: widget.profile.following ? Colors.transparent : Colors.blue,
              border: widget.profile.following ? Border.all(color:secondaryColor(context),width: 0) : null
            ),
            child: Center(
              child: Text(
                widget.profile.following ? 'Following' : 'Follow',
                style: TextStyle(
                  color: widget.profile.following ? secondaryColor(context) : primaryColor(context),
                  fontSize: deviceWidth * 0.045,
                  fontWeight: FontWeight.w600,
                ),
                ),
            ),
          ),
        )
      );
  }
}