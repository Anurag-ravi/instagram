// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:instagram/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FollowCard extends StatefulWidget {
  const FollowCard({Key? key}) : super(key: key);

  @override
  State<FollowCard> createState() => _FollowCardState();
}

class _FollowCardState extends State<FollowCard> {
  bool followed = false;
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(5),
      width: deviceWidth * 0.40,
      height: deviceWidth * 0.52,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54, width: deviceWidth * 0.002),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        children: [
          Container(
            width: deviceWidth * 0.24,
            height: deviceWidth * 0.24,
            margin: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black26,
                width: deviceWidth * 0.002,
              ),
              image: const DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  'assets/avatar.png',
                ),
              ),
            ),
          ),
          Text(
            'name',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: deviceWidth * 0.04),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                followed = !followed;
              });
            },
            child: Text(followed ? 'Unfollow' : 'Follow'),
            style: ElevatedButton.styleFrom(
              primary: followed ? Colors.grey : Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
