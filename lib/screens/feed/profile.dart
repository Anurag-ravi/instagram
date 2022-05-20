// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/components/bottomnavbar.dart';
import 'package:instagram/components/cacheimage.dart';
import 'package:instagram/components/followCard.dart';
import 'package:instagram/components/highlightcard.dart';
import 'package:instagram/data.dart';
import 'package:instagram/models/profile.dart';
import 'package:instagram/models/profile_short.dart';
import 'package:instagram/models/suggestionmodel.dart';
import 'package:instagram/screens/profile/editprofile.dart';
import 'package:instagram/screens/profile/followers.dart';
import 'package:instagram/utilities/constants.dart';
import 'package:instagram/utilities/logout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.me, this.username = ''})
      : super(key: key);
  final bool me;
  final String username;
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool posts = true;
  final controller = PageController(initialPage: 0);
  bool following = true;
  bool isvisible = false;
  bool loading = true;
  List<SuggestionModel> suggestions = [];
  ProfileModel profile = ProfileModel(
      0, 
      'username', 
      false, 
      0, 
      0, 
      0, 
      'name', 
      'bio', 
      '', 
      0, 
      [], 
      false, 
      [], 
      []);

  @override
  void initState() {
    // TODO: implement initState
    fetch();
    super.initState();
    setState(() {
      loading = false;
    });
  }

  Future<void> fetch() async {
    if (widget.me) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.getString('profile') != null){
        Map<String,dynamic> jsondatais = jsonDecode(prefs.getString('profile')!);
        setState(() {
          profile = ProfileModel.fromJson(jsondatais);
        });
      }
      if (await internetAvailable()){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = prefs.getString('token').toString();
        final response = await http.get(
          Uri.parse("${url}user/profile/"),
          headers: {
            "Authorization": token,
          },
        );
        var data = jsonDecode(jsonDecode(response.body));
        if (response.statusCode == 200) {
          setState(() {
            profile = ProfileModel.fromJson(data);
          });
          prefs.setString('profile',jsonEncode(profile));
          prefs.setString('username',profile.username);
          prefs.setString('dp',profile.dp);
          settoken(response);
        }
        if (response.statusCode == 401) {
          logout(context);
        }
      } else {
        const snackBar = SnackBar(
        content: Text('Please Connect to Internet'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') as String;
      final response = await http.post(Uri.parse("${url}user/profile/"),
          headers: <String, String>{'Authorization': token},
          body: jsonEncode({"username": widget.username}));
      var data = jsonDecode(jsonDecode(response.body));
      if (response.statusCode == 200) {
        setState(() {
          profile = ProfileModel.fromJson(data);
        });
        settoken(response);
      }
      if (response.statusCode == 401) {
        logout(context);
      }
    }
  }

  Future<void> follow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.post(Uri.parse("${url}user/follow/"),
          headers: <String, String>{'Authorization': token!},
          body: jsonEncode({"username": widget.username}));
      if (response.statusCode == 200) {
        setState(() {
          profile.meFollowing = !profile.meFollowing;
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
    double deviceWidth = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: fetch,
      child: loading ? Scaffold(
        body: Center(child: CircularProgressIndicator(color: secondaryColor(context),),),
      ) : Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xfff8faf8),
          elevation: 0.5,
          centerTitle: false,
          leading: widget.me
              ? Container()
              : IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  )),
          title: SizedBox(
            height: deviceWidth * 0.12,
            child: Column(
              children: [
                SizedBox(
                  height: deviceWidth * .02,
                ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        profile.username,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'arial',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    profile.verified
                        ? Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: deviceWidth * 0.06,
                          )
                        : widget.me
                            ? Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black,
                                size: deviceWidth * 0.07,
                              )
                            : Container(),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                bottompopup1(context);
              },
              alignment: Alignment.center,
              icon: widget.me
                  ? SvgPicture.asset('assets/add.svg',
                      height: deviceWidth * 0.09)
                  : Icon(
                      Icons.notifications_none_outlined,
                      color: Colors.black,
                      size: deviceWidth * 0.09,
                    ),
            ),
            IconButton(
              onPressed: () {
                widget.me ? bottompopup(context) : bottompopup2(context);
              },
              alignment: Alignment.center,
              icon: widget.me
                  ? Icon(
                      Icons.menu_outlined,
                      color: Colors.black,
                      size: deviceWidth * 0.09,
                    )
                  : Icon(
                      Icons.more_vert,
                      color: Colors.black,
                      size: deviceWidth * 0.09,
                    ),
            ),
          ],
        ),
        body: ListView(
          children: [
            SizedBox(
              height: deviceWidth * .01,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: deviceWidth * 0.045,
                ),
                SizedBox(
                  height: deviceWidth * .26,
                ),
                ClipOval(
                  child: Container(
                    width: deviceWidth * 0.24,
                    height: deviceWidth * 0.24,
                    child: profile.dp != ''
                        ? ChachedImage(url: profile.dp)
                        : Image.asset('assets/avatar.png'),
                  ),
                ),
                SizedBox(
                  width: deviceWidth * .1,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      profile.totalPosts.toString(),
                      style: TextStyle(
                        fontSize: deviceWidth * .05,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: deviceWidth * .01,
                    ),
                    Text(
                      'Posts',
                      style: TextStyle(
                        fontSize: deviceWidth * .04,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => Followers(me: widget.me,initialIndex: widget.me ? 0 : 1,username:widget.username)));
                  },
                  child: SizedBox(
                    width: deviceWidth * .04,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => Followers(me: widget.me,initialIndex: widget.me ? 0 : 1,username:widget.username)));
                  },
                  child: Column(
                    children: <Widget>[
                      Text(
                        profile.followers.toString(),
                        style: TextStyle(
                          fontSize: deviceWidth * .05,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: deviceWidth * .01,
                      ),
                      Text(
                        'Followers',
                        style: TextStyle(
                          fontSize: deviceWidth * .04,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => Followers(me: widget.me,initialIndex: widget.me ? 1 : 2,username:widget.username)));
                  },
                  child: SizedBox(
                    width: deviceWidth * .04,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => Followers(me: widget.me,initialIndex: widget.me ? 1 : 2,username:widget.username)));
                  },
                  child: Column(
                    children: <Widget>[
                      Text(
                        profile.following.toString(),
                        style: TextStyle(
                          fontSize: deviceWidth * .05,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: deviceWidth * .01,
                      ),
                      Text(
                        'Following',
                        style: TextStyle(
                          fontSize: deviceWidth * .04,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: deviceWidth * .02,
            ),
            Row(
              children: [
                SizedBox(
                  width: deviceWidth * 0.04,
                ),
                Text(
                  profile.name,
                  style: TextStyle(
                    fontSize: deviceWidth * .04,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(
                  width: deviceWidth * 0.05,
                ),
              ],
            ),
            SizedBox(
              height: deviceWidth * .01,
            ),
            Row(
              children: [
                SizedBox(
                  width: deviceWidth * 0.04,
                ),
                Flexible(
                  child: Text(
                    profile.bio,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      fontSize: deviceWidth * .037,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                SizedBox(
                  width: deviceWidth * 0.05,
                ),
              ],
            ),
            SizedBox(
              height: deviceWidth * .07,
            ),
            widget.me
                ? Container()
                : profile.firstMutual.isNotEmpty
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: deviceWidth * 0.04,
                          ),
                          Expanded(
                            flex: profile.firstMutual.length == 1  ? 1 : profile.firstMutual.length >= 3 ? 3 : 2,
                            child:
                                mutualLogos(profile.firstMutual, deviceWidth),
                          ),
                          SizedBox(
                            width: deviceWidth * 0.04,
                          ),
                          Expanded(
                            flex: 10,
                            child: RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: deviceWidth * 0.04,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Followed By ",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    profile.firstMutual.isNotEmpty
                                        ? TextSpan(
                                            text:
                                                profile.firstMutual[0].username,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : TextSpan(),
                                    profile.firstMutual.length > 1
                                        ? TextSpan(
                                            text: " , ",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          )
                                        : TextSpan(),
                                    profile.firstMutual.length > 1
                                        ? TextSpan(
                                            text:
                                                profile.firstMutual[1].username,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : TextSpan(),
                                    TextSpan(
                                      text: " and ",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: profile.mutualFriends.toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: " others",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                          SizedBox(
                            width: deviceWidth * 0.05,
                          ),
                        ],
                      )
                    : Container(),
            widget.me
                ? Container()
                : SizedBox(
                    height: deviceWidth * .07,
                  ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: deviceWidth * 0.03,
                ),
                widget.me
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          follow();
                        },
                        child: Container(
                          width: deviceWidth * 0.39,
                          height: deviceWidth * .11,
                          decoration: BoxDecoration(
                            color: profile.meFollowing
                                ? Colors.transparent
                                : Colors.blue,
                            border: Border.all(
                              color: profile.meFollowing
                                  ? Colors.grey
                                  : Colors.blue,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(7)),
                          ),
                          child: Center(
                            child: Text(
                              profile.meFollowing ? 'Following' : 'Follow',
                              style: TextStyle(
                                color:
                                    profile.meFollowing ? Colors.grey[600] : Colors.white,
                                fontSize: deviceWidth * .039,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  width: deviceWidth * .02,
                ),
                GestureDetector(
                  onTap: () {
                      widget.me ? Navigator.push(context, MaterialPageRoute(builder: (builder)=>EditProfile(profile: profile,))) : null;
                  },
                  child: Container(
                    width: widget.me ? deviceWidth * .81 : deviceWidth * 0.39,
                    height: deviceWidth * .11,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(7)),
                    ),
                    child: Center(
                      child: Text(
                        widget.me ? 'Edit Profile' : 'Message',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: deviceWidth * .039,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: deviceWidth * .02,
                ),
                GestureDetector(
                  onTap: () async {
                    if(!isvisible){
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      String token = prefs.getString('token') as String;
                      final response = await http.get(Uri.parse("${url}user/follow_suggestion/"),
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
                    setState(() {
                      isvisible = !isvisible;
                    });
                  },
                  child: Container(
                    width: deviceWidth * .11,
                    height: deviceWidth * .11,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(7)),
                    ),
                    child: Center(
                      child: Icon(
                        isvisible
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: isvisible,
              child: Column(
                children: [
                  SizedBox(
                    height: deviceWidth * .04,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: deviceWidth * .02,
                      ),
                      Text(
                        'Discover People',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: deviceWidth * .039,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.2,
                        ),
                      ),
                      SizedBox(
                        width: deviceWidth * .55,
                      ),
                      Text(
                        'See All',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: deviceWidth * .039,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: deviceWidth * .01,
                  ),
                  Container(
                    height: deviceWidth * 0.6,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        suggestions.length,
                        (int index) {
                          return FollowCard(profile: suggestions[index]);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: deviceWidth * .05,
            ),
            Container(
              height: deviceWidth * 0.29,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.02),
                children: List.generate(
                  10,
                  (int index) {
                    return HighlightCard();
                  },
                ),
              ),
            ),
            SizedBox(
              height: deviceWidth * .05,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: Center(
                    child: Icon(
                      Icons.view_module_outlined,
                      size: deviceWidth * 0.11,
                      color: posts ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Center(
                    child: Icon(
                      Icons.person_pin_outlined,
                      size: deviceWidth * 0.1,
                      color: posts ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    height: 2,
                    width: deviceWidth * .5,
                    color: posts ? Colors.black : Colors.grey,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    height: 2,
                    width: deviceWidth * .5,
                    color: posts ? Colors.grey : Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: deviceWidth * .015,
            ),
            Container(
              height: deviceWidth,
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: PageView(
                controller: controller,
                onPageChanged: (value) {
                  setState(() {
                    posts = value == 0;
                  });
                },
                children: [
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemCount: profile.posts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(1),
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: ChachedImage(
                            url: profile.posts[index].url,
                          ),
                        ),
                      );
                    },
                  ),
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemCount: profile.tags.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(1),
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: ChachedImage(
                            url: profile.tags[index].url,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: widget.me ? null : BottomNavTemp(),
      ),
    );
  }

  Widget mutualLogos(List<ProfileShort> frnds, double deviceWidth) {
    if (frnds.length == 1) {
      return Stack(
        children: [
          ClipOval(
            child: Container(
              width: deviceWidth * 0.08,
              height: deviceWidth * 0.08,
              child: frnds[0].url != ''
                  ? ChachedImage(
                      url: frnds[0].url,
                    )
                  : Image.asset('assets/avatar.png'),
            ),
          )
        ],
      );
    }
    if (frnds.length == 2) {
      return Stack(
        children: [
          ClipOval(
            child: Container(
              width: deviceWidth * 0.08,
              height: deviceWidth * 0.08,
              child: frnds[0].url != ''
                  ? ChachedImage(
                      url: frnds[0].url,
                    )
                  : Image.asset('assets/avatar.png'),
            ),
          ),
          Positioned(
            left: deviceWidth * 0.06,
            child: ClipOval(
              child: Container(
                width: deviceWidth * 0.08,
                height: deviceWidth * 0.08,
                child: frnds[1].url != ''
                    ? ChachedImage(
                        url: frnds[1].url,
                      )
                    : Image.asset('assets/avatar.png'),
              ),
            ),
          ),
        ],
      );
    }
    if (frnds.length == 3) {
      return Stack(
        children: [
          ClipOval(
            child: Container(
              width: deviceWidth * 0.08,
              height: deviceWidth * 0.08,
              child: frnds[0].url != ''
                  ? ChachedImage(
                      url: frnds[0].url,
                    )
                  : Image.asset('assets/avatar.png'),
            ),
          ),
          Positioned(
            left: deviceWidth * 0.06,
            child: ClipOval(
              child: Container(
                width: deviceWidth * 0.08,
                height: deviceWidth * 0.08,
                child: frnds[1].url != ''
                    ? ChachedImage(
                        url: frnds[1].url,
                      )
                    : Image.asset('assets/avatar.png'),
              ),
            ),
          ),
          Positioned(
            left: deviceWidth * 0.12,
            child: ClipOval(
              child: Container(
                width: deviceWidth * 0.08,
                height: deviceWidth * 0.08,
                child: frnds[2].url != ''
                    ? ChachedImage(
                        url: frnds[2].url,
                      )
                    : Image.asset('assets/avatar.png'),
              ),
            ),
          ),
        ],
      );
    }
    return Container();
  }
}

void bottompopup(context) {
  double devicewidth = MediaQuery.of(context).size.width;
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Flexible(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            // height: devicewidth,
            child: Flexible(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Center(
                      child: Container(
                        width: devicewidth * 0.15,
                        height: 4,
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    child: Row(
                      children: [
                        SizedBox(
                          width: devicewidth * 0.05,
                        ),
                        Icon(
                          Icons.settings_rounded,
                          size: devicewidth * 0.07,
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: devicewidth * 0.03,
                        ),
                        Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: devicewidth * 0.055,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    child: Row(
                      children: [
                        SizedBox(
                          width: devicewidth * 0.05,
                        ),
                        Icon(
                          Icons.access_time_rounded,
                          size: devicewidth * 0.07,
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: devicewidth * 0.03,
                        ),
                        Text(
                          'Activity',
                          style: TextStyle(
                            fontSize: devicewidth * 0.055,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    child: Row(
                      children: [
                        SizedBox(
                          width: devicewidth * 0.05,
                        ),
                        Icon(
                          Icons.qr_code_scanner_rounded,
                          size: devicewidth * 0.07,
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: devicewidth * 0.03,
                        ),
                        Text(
                          'QR Code',
                          style: TextStyle(
                            fontSize: devicewidth * 0.055,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    child: Row(
                      children: [
                        SizedBox(
                          width: devicewidth * 0.05,
                        ),
                        Icon(
                          Icons.bookmark_border_rounded,
                          size: devicewidth * 0.07,
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: devicewidth * 0.03,
                        ),
                        Text(
                          'Saved',
                          style: TextStyle(
                            fontSize: devicewidth * 0.055,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    child: Row(
                      children: [
                        SizedBox(
                          width: devicewidth * 0.05,
                        ),
                        Icon(
                          Icons.format_list_bulleted_sharp,
                          size: devicewidth * 0.07,
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: devicewidth * 0.03,
                        ),
                        Text(
                          'Close Friends',
                          style: TextStyle(
                            fontSize: devicewidth * 0.055,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    child: Row(
                      children: [
                        SizedBox(
                          width: devicewidth * 0.05,
                        ),
                        Icon(
                          Icons.star_border_outlined,
                          size: devicewidth * 0.07,
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: devicewidth * 0.03,
                        ),
                        Text(
                          'Favourites',
                          style: TextStyle(
                            fontSize: devicewidth * 0.055,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    child: GestureDetector(
                      onTap: () async {
                        logout(context);
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: devicewidth * 0.05,
                          ),
                          Icon(
                            Icons.logout,
                            size: devicewidth * 0.07,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: devicewidth * 0.03,
                          ),
                          Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: devicewidth * 0.055,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

void bottompopup1(context) {
  double devicewidth = MediaQuery.of(context).size.width;
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          height: devicewidth,
          child: Flexible(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Center(
                    child: Container(
                      width: devicewidth * 0.15,
                      height: 4,
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Center(
                    child: Text(
                      'Create',
                      style: TextStyle(
                        fontSize: devicewidth * 0.06,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  height: 5,
                  thickness: 1,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  child: Row(
                    children: [
                      SizedBox(
                        width: devicewidth * 0.05,
                      ),
                      Icon(
                        Icons.view_module_outlined,
                        size: devicewidth * 0.07,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        width: devicewidth * 0.03,
                      ),
                      Text(
                        'Post',
                        style: TextStyle(
                          fontSize: devicewidth * 0.055,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  child: Row(
                    children: [
                      SizedBox(
                        width: devicewidth * 0.05,
                      ),
                      Icon(
                        Icons.video_collection_outlined,
                        size: devicewidth * 0.07,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        width: devicewidth * 0.03,
                      ),
                      Text(
                        'Reels',
                        style: TextStyle(
                          fontSize: devicewidth * 0.055,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  child: Row(
                    children: [
                      SizedBox(
                        width: devicewidth * 0.05,
                      ),
                      Icon(
                        Icons.add_circle_outline_rounded,
                        size: devicewidth * 0.07,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        width: devicewidth * 0.03,
                      ),
                      Text(
                        'Story',
                        style: TextStyle(
                          fontSize: devicewidth * 0.055,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  child: Row(
                    children: [
                      SizedBox(
                        width: devicewidth * 0.05,
                      ),
                      Icon(
                        Icons.favorite_outline_rounded,
                        size: devicewidth * 0.07,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        width: devicewidth * 0.03,
                      ),
                      Text(
                        'Story Highlight',
                        style: TextStyle(
                          fontSize: devicewidth * 0.055,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  child: Row(
                    children: [
                      SizedBox(
                        width: devicewidth * 0.05,
                      ),
                      Icon(
                        Icons.wifi_tethering,
                        size: devicewidth * 0.07,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        width: devicewidth * 0.03,
                      ),
                      Text(
                        'Live',
                        style: TextStyle(
                          fontSize: devicewidth * 0.055,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

void bottompopup2(context) {
  double devicewidth = MediaQuery.of(context).size.width;
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Flexible(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            // height: devicewidth * 1.2,
            child: Flexible(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Center(
                      child: Container(
                        width: devicewidth * 0.15,
                        height: 4,
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    child: Row(
                      children: [
                        SizedBox(
                          width: devicewidth * 0.05,
                        ),
                        Icon(
                          Icons.report,
                          size: devicewidth * 0.07,
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: devicewidth * 0.03,
                        ),
                        Text(
                          'Report',
                          style: TextStyle(
                            fontSize: devicewidth * 0.055,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    child: Row(
                      children: [
                        SizedBox(
                          width: devicewidth * 0.05,
                        ),
                        Icon(
                          Icons.block,
                          size: devicewidth * 0.07,
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: devicewidth * 0.03,
                        ),
                        Text(
                          'Block',
                          style: TextStyle(
                            fontSize: devicewidth * 0.055,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    child: Row(
                      children: [
                        SizedBox(
                          width: devicewidth * 0.05,
                        ),
                        Icon(
                          Icons.no_accounts_rounded,
                          size: devicewidth * 0.07,
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: devicewidth * 0.03,
                        ),
                        Text(
                          'Restrict',
                          style: TextStyle(
                            fontSize: devicewidth * 0.055,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    child: Row(
                      children: [
                        SizedBox(
                          width: devicewidth * 0.05,
                        ),
                        Icon(
                          Icons.hide_image_outlined,
                          size: devicewidth * 0.07,
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: devicewidth * 0.03,
                        ),
                        Text(
                          'Hide your Story',
                          style: TextStyle(
                            fontSize: devicewidth * 0.055,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    child: Row(
                      children: [
                        SizedBox(
                          width: devicewidth * 0.05,
                        ),
                        Icon(
                          Icons.remove_circle_outline_sharp,
                          size: devicewidth * 0.07,
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: devicewidth * 0.03,
                        ),
                        Text(
                          'Remove Follower',
                          style: TextStyle(
                            fontSize: devicewidth * 0.055,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    child: Row(
                      children: [
                        SizedBox(
                          width: devicewidth * 0.05,
                        ),
                        Icon(
                          Icons.link_rounded,
                          size: devicewidth * 0.07,
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: devicewidth * 0.03,
                        ),
                        Text(
                          'Copy Profile URL',
                          style: TextStyle(
                            fontSize: devicewidth * 0.055,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    child: GestureDetector(
                      onTap: () async {},
                      child: Row(
                        children: [
                          SizedBox(
                            width: devicewidth * 0.05,
                          ),
                          Icon(
                            Icons.share_rounded,
                            size: devicewidth * 0.07,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: devicewidth * 0.03,
                          ),
                          Text(
                            'Share Profile',
                            style: TextStyle(
                              fontSize: devicewidth * 0.055,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
