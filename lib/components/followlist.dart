import 'package:flutter/material.dart';
import 'package:instagram/components/followcard.dart';
import 'package:instagram/models/followmodel.dart';

class FollowList extends StatefulWidget {
  const FollowList({Key? key, required this.followlist}) : super(key: key);
  final List<FollowModel> followlist;

  @override
  State<FollowList> createState() => _FollowListState();
}

class _FollowListState extends State<FollowList> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height: deviceWidth * .01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: deviceWidth * .95,
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
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
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
            (index) => FollowCard(),
          ),
        ))
      ],
    );
  }
}
