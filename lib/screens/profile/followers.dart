// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:instagram/components/followlist.dart';

class Followers extends StatefulWidget {
  const Followers({Key? key, required this.me}) : super(key: key);
  final bool me;

  @override
  State<Followers> createState() => _FollowersState();
}

class _FollowersState extends State<Followers> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    _tabController = TabController(length: widget.me ? 2 :4, initialIndex: widget.me ? 0 : 1, vsync: this)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('anu.rag__r'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            controller: _tabController,
            tabs: [
              Container(
                // width: devicewidth * 0.193,
                alignment: Alignment.center,
                child: Text("Mutual"),
              ),
              Container(
                // width: devicewidth * 0.193,
                alignment: Alignment.center,
                child: Text("Followers"),
              ),
              Container(
                // width: devicewidth * 0.193,
                alignment: Alignment.center,
                child: Text("Following"),
              ),
              Container(
                // width: devicewidth * 0.193,
                alignment: Alignment.center,
                child: Text("Suggested"),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            FollowList(followlist: [],),
            FollowList(followlist: [],),
            FollowList(followlist: [],),
            FollowList(followlist: [],),
          ],
        )
    );
  }
}
