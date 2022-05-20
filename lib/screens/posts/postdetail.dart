import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:instagram/components/cacheimage.dart';
import 'package:instagram/components/postcard.dart';
import 'package:instagram/data.dart';
import 'package:instagram/main.dart';
import 'package:instagram/models/commentmodel.dart';
import 'package:instagram/models/postmodel.dart';
import 'package:instagram/utilities/constants.dart';
import 'package:instagram/utilities/logout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PostDetail extends StatefulWidget {
  const PostDetail(
      {Key? key,
      required this.post,
      required this.comments,
      required this.prefs})
      : super(key: key);
  final PostModel post;
  final List<CommentModel> comments;
  final SharedPreferences prefs;

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  List<CommentModel> comments = [];
  TextEditingController commentcontroller = TextEditingController();
  bool updating = false;
  int updatingid = 0;

  @override
  void initState() {
    // TODO: implement initState
    fetch();
    super.initState();
  }

  Future<void> fetch() async {
    String? token = widget.prefs.getString('token');
    final response = await http.get(
      Uri.parse("${url}post/${widget.post.id}/"),
      headers: <String, String>{'Authorization': token!},
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        comments = (data as List).map((e) => CommentModel.fromJson(e)).toList();
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
  Future<void> like(index) async {
    String? token = widget.prefs.getString('token');
    final response = await http.get(
      Uri.parse("${url}comment/like/${index}/"),
      headers: <String, String>{'Authorization': token!},
    );
    if (response.statusCode == 200) {
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

  Future<void> comment() async {
    FocusManager.instance.primaryFocus!.unfocus();
    String? token = widget.prefs.getString('token');
    final response = await http.post(
      Uri.parse("${url}comment/new/"),
      headers: <String, String>{
        'Authorization': token!,
        "Content-type": "application/json"
        },
      body: jsonEncode({
        "commentor": widget.prefs.getInt('id'),
        "content":commentcontroller.text,
        "post":widget.post.id
        })
    );
    if (response.statusCode == 201) {
      var data = jsonDecode(response.body);
      setState(() {
        comments.insert(0,CommentModel(data['id'], widget.prefs.getString('dp')!, widget.prefs.getString('username')!, commentcontroller.text, '0s', 0, false));
      });
      commentcontroller.text='';
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
  
  Future<void> update() async {
    FocusManager.instance.primaryFocus!.unfocus();
    String? token = widget.prefs.getString('token');
    final response = await http.put(
      Uri.parse("${url}comment/edit/${updatingid}/"),
      headers: <String, String>{
        'Authorization': token!,
        "Content-type": "application/json"
        },
      body: jsonEncode({
        "content":commentcontroller.text
        })
    );
    if (response.statusCode == 201) {
      setState(() {
        var updated = comments.firstWhere((element) => element.id == updatingid);
        int ind = comments.indexOf(updated);
        comments[ind].comment = commentcontroller.text;
        updating = false;
        updatingid = 0;
      });
      commentcontroller.text='';
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

  Future<void> delete(index) async {
    FocusManager.instance.primaryFocus!.unfocus();
    String? token = widget.prefs.getString('token');
    final response = await http.delete(
      Uri.parse("${url}comment/delete/${index}/"),
      headers: <String, String>{'Authorization': token!},
    );
    if (response.statusCode == 204) {
      setState(() {
        var del = comments.firstWhere((element) => element.id == index);
        comments.remove(del);
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
      onRefresh: fetch,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xfff8faf8),
          elevation: 0.5,
          centerTitle: false,
          title: Text(
            'Comments',
            style: TextStyle(color: secondaryColor(context)),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: secondaryColor(context),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                bottompopup(context);
              },
              icon: Icon(
                Icons.more_vert_rounded,
                color: secondaryColor(context),
              ),
            ),
          ],
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView.builder(
              itemCount: comments.length + 3,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return PostCard(
                    post: widget.post,
                    prefs: widget.prefs,
                    isdetail: true,
                  );
                }
                if (index == 1) {
                  return const Divider(
                    height: 5,
                    thickness: 1,
                  );
                }
                if (index == comments.length + 2) {
                  return SizedBox(height: 100,);
                }
                var com = comments[index - 2];
                return GestureDetector(
                  onLongPress: () {
                    bottompopup2(context, com.id, com.authorUsername, widget.prefs.getString('username')!,com.comment);
                  },
                  onTap: () {
                    setState(() {
                      updating = false;
                      updatingid = 0;
                    });
                    commentcontroller.text = '';
                  },
                  child: ListTile(
                    tileColor: updating && updatingid == com.id ? Colors.grey[300]: Colors.white,
                      leading: ClipOval(
                        child: Container(
                            width: deviceWidth * 0.12,
                            height: deviceWidth * 0.12,
                            child: com.authorDp != ''
                                ? ChachedImage(url: com.authorDp)
                                : Image.asset('assets/avatar.png')),
                      ),
                      title: RichText(
                        overflow: TextOverflow.visible,
                        text: TextSpan(
                            style: TextStyle(
                              color: secondaryColor(context),
                              fontSize: deviceWidth * 0.037,
                            ),
                            children: [
                              TextSpan(
                                text: com.authorUsername + ' : ',
                                style: TextStyle(
                                  color: secondaryColor(context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: com.comment,
                                style: TextStyle(
                                  color: secondaryColor(context),
                                ),
                              ),
                            ]),
                      ),
                      subtitle: Text(
                        com.ago + '    ' + com.likes.toString() + ' likes',
                        style: TextStyle(
                          fontSize: deviceWidth * 0.034,
                        ),
                      ),
                      trailing: GestureDetector(
                          onTap: () async{
                            like(com.id);
                            setState(() {
                              com.liked = !com.liked;
                            });
                            if (com.liked) {
                              setState(() {
                                com.likes = com.likes + 1;
                              });
                            }
                            if (!com.liked) {
                              setState(() {
                                com.likes = com.likes - 1;
                              });
                            }
                          },
                          child: Icon(
                            com.liked
                                ? Icons.favorite
                                : Icons.favorite_border_rounded,
                            color:
                                com.liked ? Colors.red : secondaryColor(context),
                          ))),
                );
              },
            ),
            Container(
          color: Color(0xfff1f1f1),
          width: deviceWidth,
          padding: EdgeInsets.only(bottom: 20, left: 5, right: 5, top: 10),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: ClipOval(
                  child: Container(
                      width: deviceWidth * 0.12,
                      height: deviceWidth * 0.12,
                      child: prefs.getString('dp')! != ''
                          ? ChachedImage(url: prefs.getString('dp')!)
                          : Image.asset('assets/avatar.png')),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 12,
                child: TextField(
                  controller: commentcontroller,
                  cursorColor: Colors.grey,
                  style: TextStyle(
                    fontSize: deviceWidth * .040,
                  ),
                  decoration:  const InputDecoration.collapsed(
                    hintText: 'Add a Comment....',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    )
                  )
                ),
              ),
              Expanded(
                flex: 2,
                child: IconButton(
                  onPressed: () {
                    updating ? update() : comment();
                  },
                  icon: Icon(Icons.send_rounded),
                )
                )
            ],
          ),
        ),
          ],
        ),
      ),
    );
  }

  void bottompopup(context) {
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
            height: devicewidth * 0.5,
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
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: devicewidth * 0.05,
                        ),
                        Icon(
                          Icons.report,
                          size: devicewidth * 0.07,
                          color: Colors.redAccent,
                        ),
                        SizedBox(
                          width: devicewidth * 0.025,
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
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: devicewidth * 0.05,
                        ),
                        Icon(
                          Icons.link,
                          size: devicewidth * 0.07,
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: devicewidth * 0.025,
                        ),
                        Text(
                          'Copy Link',
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
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: devicewidth * 0.05,
                        ),
                        Icon(
                          Icons.share,
                          size: devicewidth * 0.07,
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: devicewidth * 0.025,
                        ),
                        Text(
                          'Share',
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

  void bottompopup2(context,index,username,me,value) {
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
            height: devicewidth * 0.5,
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
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: devicewidth * 0.05,
                        ),
                        Icon(
                          Icons.report,
                          size: devicewidth * 0.07,
                          color: Colors.redAccent,
                        ),
                        SizedBox(
                          width: devicewidth * 0.025,
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
                  username == me ? GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        updating=true;
                        updatingid = index;
                      });
                      commentcontroller.text  = value;
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: devicewidth * 0.05,
                          ),
                          Icon(
                            Icons.edit,
                            size: devicewidth * 0.07,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: devicewidth * 0.025,
                          ),
                          Text(
                            'Update',
                            style: TextStyle(
                              fontSize: devicewidth * 0.055,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ) : Container(),
                  username == me ?  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      delete(index);
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: devicewidth * 0.05,
                          ),
                          Icon(
                            Icons.delete_outline_rounded,
                            size: devicewidth * 0.07,
                            color: Colors.redAccent,
                          ),
                          SizedBox(
                            width: devicewidth * 0.025,
                          ),
                          Text(
                            'Delete',
                            style: TextStyle(
                              fontSize: devicewidth * 0.055,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ) : Container(),
                ],
              ),
            ),
          );
        });
  }
}
