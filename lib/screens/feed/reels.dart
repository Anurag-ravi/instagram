// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Reels extends StatelessWidget {
  const Reels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: Row(
        children: [
          SizedBox(
            width: deviceWidth * .25,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  'Itna\naata to\nZuku\nbhaiya\ndeal kr\nchuke\nhote\n😏',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 50,
                      overflow: TextOverflow.clip),
                      textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }
}
