import 'package:flutter/material.dart';
import 'package:instagram/components/followcard.dart';
import 'package:instagram/components/profilecard.dart';
import 'package:instagram/models/followmodel.dart';
import 'package:instagram/models/suggestionmodel.dart';

class FollowList extends StatefulWidget {
  const FollowList({Key? key, required this.followlist,this.issuggestions = false,required this.suggestionlist}) : super(key: key);
  final List<FollowModel> followlist;
  final bool issuggestions;
  final List<SuggestionModel> suggestionlist;

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
          height: deviceWidth * .02,
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
        const Divider(
          height: 5,
          thickness: 1,
        ),
        Expanded(
            child: widget.issuggestions ? 
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
              itemCount: widget.suggestionlist.length,
              itemBuilder: (context, index) {
                      return FollowCard(profile: widget.suggestionlist[index]);
                    },
              ) 
            :ListView(
            children: List.generate(
            widget.followlist.length,
              (index) => ProfileCard(profile: widget.followlist[index],profile2: SuggestionModel('', 'username', 'name', false, false, 'followedBy'),),
            ),
        ))
      ],
    );
  }
}
