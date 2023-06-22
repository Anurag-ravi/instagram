// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:instagram/components/followlist.dart';
import 'package:instagram/models/followmodel.dart';
import 'package:instagram/models/suggestionmodel.dart';
import 'package:instagram/utilities/constants.dart';
import 'package:instagram/utilities/logout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class Followers extends StatefulWidget {
  const Followers({Key? key, required this.me,required this.initialIndex,this.username = ''}) : super(key: key);
  final bool me;
  final int initialIndex;
  final String username;

  @override
  State<Followers> createState() => _FollowersState();
}

class _FollowersState extends State<Followers> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<FollowModel> mutual = [];
  List<FollowModel> followers = [];
  List<FollowModel> following = [];
  List<SuggestionModel> suggestion = [];
  late SharedPreferences prefs;


  @override
  void initState() {
    init();
    fetchFollowers();
    _tabController = TabController(length: widget.me ? 2 :4, initialIndex: widget.initialIndex, vsync: this)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }
  init() async {
    SharedPreferences temp = await SharedPreferences.getInstance();
    setState(() {
      prefs = temp;
    });
  }

  Future<void> fetchFollowers() async {
    var temp =  await SharedPreferences.getInstance();
    setState(() {
       prefs = temp;
    });
      String? token = prefs.getString('token');
      String? url = prefs.getString('url');
      http.Response response;
      if(widget.me){
        response = await http.get(Uri.parse("${url!}user/get_followers/"),
          headers: <String, String>{'Authorization': token!},
          );
      } else {
        response = await http.post(Uri.parse("${url!}user/get_followers/"),
          headers: <String, String>{'Authorization': token!},
          body: jsonEncode({"username": widget.username}));
      }
      if (response.statusCode == 200) {
        var data = jsonDecode(jsonDecode(response.body));
        setState(() {
          mutual = (data['mutual'] as List).map((e) => FollowModel.fromJson(e)).toList();
          followers = (data['followers'] as List).map((e) => FollowModel.fromJson(e)).toList();
          following = (data['following'] as List).map((e) => FollowModel.fromJson(e)).toList();
          suggestion = (data['suggestion'] as List).map((e) => SuggestionModel.fromJson(e)).toList();
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


  @override
  Widget build(BuildContext context) {
    double devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: primaryColor(context),
      appBar: AppBar(
        title: Text(widget.me ? prefs.getString('username')! : widget.username,style: TextStyle(color: secondaryColor(context)),),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: secondaryColor(context),
          ),
        ),
        bottom: TabBar(
            isScrollable: true,
            indicatorColor: secondaryColor(context),
            controller: _tabController,
            tabs: widget.me ? [
              Container(
                width: devicewidth * 0.41,
                padding: EdgeInsets.only(bottom: 5),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(followers.length.toString(),style: TextStyle(color: secondaryColor(context)),),
                    Text("Followers",style: TextStyle(color: secondaryColor(context)),),
                  ],
                ),
              ),
              Container(
                width: devicewidth * 0.41,
                padding: EdgeInsets.only(bottom: 5),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(following.length.toString(),style: TextStyle(color: secondaryColor(context)),),
                    Text("Following",style: TextStyle(color: secondaryColor(context)),),
                  ],
                ),
              ),
            ] : [
              Container(
                width: devicewidth * 0.2,
                padding: EdgeInsets.only(bottom: 5),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(mutual.length.toString(),style: TextStyle(color: secondaryColor(context)),),
                    Text("Mutual",style: TextStyle(color: secondaryColor(context)),),
                  ],
                ),
              ),
              Container(
                width: devicewidth * 0.2,
                padding: EdgeInsets.only(bottom: 5),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(followers.length.toString(),style: TextStyle(color: secondaryColor(context)),),
                    Text("Followers",style: TextStyle(color: secondaryColor(context)),),
                  ],
                ),
              ),
              Container(
                width: devicewidth * 0.2,
                padding: EdgeInsets.only(bottom: 5),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(following.length.toString(),style: TextStyle(color: secondaryColor(context)),),
                    Text("Following",style: TextStyle(color: secondaryColor(context)),),
                  ],
                ),
              ),
              Container(
                width: devicewidth * 0.2,
                padding: EdgeInsets.only(bottom: 5),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text("",style: TextStyle(color: secondaryColor(context)),),
                    Text("Suggested",style: TextStyle(color: secondaryColor(context)),),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: widget.me ? [
            FollowList(followlist: followers,issuggestions: false,suggestionlist: suggestion,),
            FollowList(followlist: following,issuggestions: false,suggestionlist: suggestion,),
          ] : [
            FollowList(followlist: mutual,issuggestions: false,suggestionlist: suggestion,),
            FollowList(followlist: followers,issuggestions: false,suggestionlist: suggestion,),
            FollowList(followlist: following,issuggestions: false,suggestionlist: suggestion,),
            FollowList(followlist: [],issuggestions: true,suggestionlist: suggestion,),
          ],
        )
    );
  }
}
