// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class DmScreen extends StatefulWidget {
  const DmScreen({Key? key, required this.controller}) : super(key: key);
  final PageController controller;
  @override
  State<DmScreen> createState() => _DmScreenState();
}

class _DmScreenState extends State<DmScreen> {
  bool verified = true;
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: new Color(0xfff8faf8),
        elevation: 0.0,
        title: SizedBox(
          height: deviceWidth * 0.12,
          child: Column(
            children: [
              SizedBox(
                height: deviceWidth * .02,
              ),
              Row(
                children: [
                  const Flexible(
                    child: Text(
                      'anu.rag__r n n n n n nn n n n n n  n nn  nn',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'arial',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  verified
                      ? Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: deviceWidth * 0.06,
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
        leading: IconButton(
          onPressed: () {
            widget.controller.animateToPage(1,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          },
          alignment: Alignment.centerLeft,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: deviceWidth * 0.08,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            alignment: Alignment.center,
            icon: Icon(
              Icons.videocam_rounded,
              color: Colors.black,
              size: deviceWidth * 0.08,
            ),
          ),
          IconButton(
            onPressed: () {},
            alignment: Alignment.center,
            icon: Icon(
              Icons.add,
              color: Colors.black,
              size: deviceWidth * 0.08,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  SizedBox(
                    height: deviceWidth * .01,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: deviceWidth * 0.045,
                      ),
                      SizedBox(
                        height: deviceWidth * .16,
                      ),
                      Container(
                        width: deviceWidth * .90,
                        height: deviceWidth * .12,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Center(
                            child: TextField(
                              onChanged: (text) {},
                              style: TextStyle(
                                fontSize: deviceWidth * .040,
                              ),
                              decoration: InputDecoration.collapsed(
                                hintText: ' Search',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                List.generate(
                  17,
                  (int index) {
                    return GestureDetector(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage("assets/avatar.png"),
                          radius: deviceWidth * 0.08,
                        ),
                        title: Text(
                          'name',
                          style: TextStyle(
                            fontSize: deviceWidth * 0.041,
                          ),
                        ),
                        subtitle: Text(
                          'message',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: deviceWidth * 0.038,
                            color: Colors.grey[400],
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.camera_alt_outlined,
                            size: deviceWidth * 0.08,
                            color: Colors.grey[500],
                          ),
                          alignment: Alignment.centerRight,
                        ),
                        onLongPress: () {
                          bottompopup(context, index);
                        },
                      ),
                    );
                    // Column(
                    //   children: <Widget>[
                    //     SizedBox(height: deviceWidth * 0.06,),
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: <Widget>[
                    //         SizedBox(width: deviceWidth * 0.04,),
                    //         Expanded(
                    //           flex: 2,
                    //           child: CircleAvatar(
                    //             backgroundImage: AssetImage("assets/postusers/user$index.jpeg"),
                    //             radius: deviceWidth * 0.08,
                    //           ),
                    //         ),
                    //         SizedBox(width: deviceWidth * 0.04,),
                    //         Expanded(
                    //           flex: 7,
                    //           child: Column(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: <Widget>[
                    //               SizedBox(height: deviceWidth * 0.01,),
                    //               Text(
                    //                 '${postusers[index]}',
                    //                 style: TextStyle(
                    //                   fontSize: deviceWidth * 0.041,
                    //                 ),
                    //               ),
                    //               SizedBox(height: deviceWidth * 0.02,),
                    //               Text(
                    //                     '${messages[index]}',
                    //                 overflow: TextOverflow.ellipsis,
                    //                     style: TextStyle(
                    //                       fontSize: deviceWidth * 0.038,
                    //                       color: Colors.grey[400],
                    //                     ),
                    //                   ),
                    //               SizedBox(height: deviceWidth * 0.03,),
                    //             ],
                    //           ),
                    //         ),
                    //         Expanded(
                    //           flex: 1,
                    //           child: Column(
                    //             children: [
                    //               SizedBox(height: deviceWidth * 0.045,),
                    //               Text(
                    //                 '${timings[index]}',
                    //                 overflow: TextOverflow.ellipsis,
                    //                 style: TextStyle(
                    //                   fontSize: deviceWidth * 0.038,
                    //                   color: Colors.grey[400],
                    //
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         Expanded(
                    //           flex: 2,
                    //           child: IconButton(
                    //             onPressed: () {},
                    //             icon: Icon(
                    //               Icons.camera_alt_outlined,
                    //               size: deviceWidth * 0.08,
                    //               color: Colors.grey[500],
                    //             ),
                    //             alignment: Alignment.centerRight,
                    //           ),
                    //         ),
                    //         SizedBox(width: deviceWidth * 0.04,),
                    //       ],
                    //     ),
                    //   ],
                    // )
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void bottompopup(context, index) {
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
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Center(
                      child: Text(
                        'Username',
                        style: TextStyle(
                            fontSize: devicewidth * 0.07,
                            fontWeight: FontWeight.w600),
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
                      onTap: () async {},
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
