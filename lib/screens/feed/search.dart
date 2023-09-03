// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:instagram/components/profilecard.dart';
import 'package:instagram/models/followmodel.dart';
import 'package:instagram/models/suggestionmodel.dart';
import 'package:instagram/utilities/constants.dart';
import 'package:instagram/utilities/logout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  TabController? _tabController;
  List<FollowModel> searchResult = [];
  List<SuggestionModel> suggestions = [];

  @override
  void initState() {
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this)
      ..addListener(() {
        setState(() {});
      });
    getsuggestion();
    super.initState();
  }
  
  getsuggestion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') as String;
    String? url = prefs.getString('url');
    final response = await http.get(Uri.parse("${url!}user/follow_suggestion/"),
        headers: <String, String>{'Authorization': token},
        );
    if (response.statusCode == 200) {
      var data = jsonDecode(jsonDecode(response.body)) as List;
      setState(() {
        suggestions = data.map((e) => SuggestionModel.fromJson(e)).toList();
      });
    }
    if (response.statusCode == 401) {
      logout(context);
    }
  }
  getsearch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') as String;
    String? url = prefs.getString('url');
    final response = await http.post(Uri.parse("${url!}user/search/"),
        headers: <String, String>{'Authorization': token},
        body: jsonEncode({"query": searchController.text})
        );
    if (response.statusCode == 200) {
      var data = jsonDecode(jsonDecode(response.body)) as List;
      setState(() {
        searchResult = data.map((e) => FollowModel.fromJson(e)).toList();
      });
    }
    if (response.statusCode == 401) {
      logout(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    double devicewidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: devicewidth * .03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: devicewidth * .91,
                  height: devicewidth * .12,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: TextField(
                        controller: searchController,
                        cursorColor: Colors.grey,
                        onChanged: (text) {
                          getsearch();
                        },
                        style: TextStyle(
                          fontSize: devicewidth * .040,
                        ),
                        decoration: const InputDecoration.collapsed(
                          hintText: ' Search',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: devicewidth * .05,
            ),
            Container(
              child: TabBar(
                isScrollable: true,
                indicatorColor: secondaryColor(context),
                controller: _tabController,
                tabs: [
                  Container(
                    width: devicewidth * 0.41,
                    padding: EdgeInsets.only(bottom: 5),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          "Results",
                          style: TextStyle(color: secondaryColor(context)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: devicewidth * 0.41,
                    padding: EdgeInsets.only(bottom: 5),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          "Suggestions",
                          style: TextStyle(color: secondaryColor(context)),
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //   width: devicewidth * 0.2,
                  //   padding: EdgeInsets.only(bottom: 5),
                  //   alignment: Alignment.center,
                  //   child: Column(
                  //     children: [
                  //       Text("Posts",style: TextStyle(color: secondaryColor(context)),),
                  //     ],
                  //   ),
                  // ),
                  // Container(
                  //   width: devicewidth * 0.2,
                  //   padding: EdgeInsets.only(bottom: 5),
                  //   alignment: Alignment.center,
                  //   child: Column(
                  //     children: [
                  //       Text("Trending",style: TextStyle(color: secondaryColor(context)),),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView.builder(
                      itemCount: searchResult.length,
                      itemBuilder: (context, index) {
                        return ProfileCard(profile: searchResult[index],profile2: SuggestionModel('', 'username', 'name', false, false, 'followedBy'),);
                      },
                    ),
                    ListView.builder(
                      itemCount: suggestions.length,
                      itemBuilder: (context, index) {
                        return ProfileCard(profile: FollowModel('', '', 'name', false),profile2: suggestions[index],issuggestion: true,);
                      },
                    ),
                  ]
                  ), 
                ),
          ],
        ),
      ),
    );
  }
}
