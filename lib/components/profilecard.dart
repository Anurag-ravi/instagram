// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({ Key? key }) : super(key: key);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool followed = false;
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return ListTile(
        leading: CircleAvatar(
          radius: deviceWidth * 0.07,
          backgroundImage: AssetImage('assets/avatar.png'),
        ),
        title: Text(
          'Username',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('Name'),
        trailing: ElevatedButton(
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
      );
  }
}