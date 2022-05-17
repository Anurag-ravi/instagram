// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:instagram/components/profilecard.dart';
import 'package:instagram/models/followmodel.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: deviceWidth * .03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: deviceWidth * .91,
                  height: deviceWidth * .12,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: TextField(
                        cursorColor: Colors.grey,
                        onChanged: (text) {},
                        style: TextStyle(
                          fontSize: deviceWidth * .040,
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
            Container(
              height: deviceWidth * 0.15,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  10,
                  (int index) {
                    return Container(
                      width: deviceWidth * 0.20,
                      height: deviceWidth * 0.10,
                      margin: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: Colors.grey,
                          width: deviceWidth * 0.003,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Center(
                        child: Text(
                          'hehe',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const Divider(
              height: 5,
              thickness: 1,
            ),
            Expanded(
              child: ListView(
                children: List.generate(
                    10,
                    (index) => ProfileCard(profile: FollowModel('','username','name',false),),
              ),
            )
            )
          ],
        ),
      ),
    );
  }
}
