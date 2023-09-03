import 'package:flutter/material.dart';

List<String> postusers = [
  'the_shutter_on',
  'kiranpragya2216',
  'prrtk_',
  'singhveeru_03_',
  'shruti__.2003',
  'vaishnavi_kalhapure',
  'virat.kolhi',
  'mahi7781',
  'abhiandniyu',
  'rohitsharma45',
  'divyendu',
  'bajpayee.manoj',
  'pankajtripathi',
  'hindujasunny',
  'nidhiagerwal',
  'beerbiceps',
  'lacasadepapel',
];

List<String> messages = [
  "replied to your comment on nubu_chzngs07's post",
  'mentioned you in a comment: @anu.rag__r 😂😂',
  'liked you comment: Awesome pic dear 🥰🥰💝',
];
class Activity extends StatefulWidget {
  const Activity({ Key? key }) : super(key: key);

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff8faf8),
        elevation: 0.0,
        centerTitle: true,
        title: SizedBox(
          height: deviceWidth * 0.12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: deviceWidth * .02,),
              Text(
                'Activity(Feature coming Soon)',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: deviceWidth * 0.05,
                  fontFamily: 'arial',
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(delegate: SliverChildListDelegate(
              <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: deviceWidth * 0.04,),
                    Text(
                        'Today',
                      style: TextStyle(
                        fontSize: deviceWidth * 0.05,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),),
            SliverList(
              delegate: SliverChildListDelegate(
                List.generate(
                  3,
                      (int index) {
                    return Column(
                      children: <Widget>[
                        SizedBox(height: deviceWidth * 0.06,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(width: deviceWidth * 0.04,),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: const AssetImage("assets/avatar.png"),
                                    radius: deviceWidth * 0.08,
                                  ),
                                  SizedBox(height: deviceWidth * 0.09,),
                                ],
                              ),
                            ),
                            SizedBox(width: deviceWidth * 0.04,),
                            Expanded(
                              flex: 7,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  SizedBox(height: deviceWidth * 0.02,),
                                  Text(
                                    '${postusers[index]} ${messages[index]}',
                                    style: TextStyle(
                                      fontSize: deviceWidth * 0.041,
                                    ),
                                  ),
                                  SizedBox(height: deviceWidth * 0.06,),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.favorite_border_outlined,size: deviceWidth * 0.045,color: Colors.grey[500],),
                                      Text('      Reply',style: TextStyle(fontSize: deviceWidth * .034,color: Colors.grey[500]),),
                                    ],
                                  ),
                                  SizedBox(height: deviceWidth * 0.0,),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  Container(
                                    width: deviceWidth * 0.17,
                                    height: deviceWidth * 0.17,
                                    margin: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage("assets/avatar.png")
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: deviceWidth * .05,),
                                ],
                              ),
                            ),
                            SizedBox(width: deviceWidth * 0.01,),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            SliverList(delegate: SliverChildListDelegate(
              <Widget>[
                SizedBox(height: deviceWidth * .07,),
                Row(
                  children: <Widget>[
                    SizedBox(width: deviceWidth * 0.04,),
                    Text(
                      'Yesterday',
                      style: TextStyle(
                        fontSize: deviceWidth * 0.05,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),),
            SliverList(
              delegate: SliverChildListDelegate(
                List.generate(
                  3,
                      (int index) {
                    return Column(
                      children: <Widget>[
                        SizedBox(height: deviceWidth * 0.06,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(width: deviceWidth * 0.04,),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: const AssetImage("assets/avatar.png"),
                                    radius: deviceWidth * 0.08,
                                  ),
                                  SizedBox(height: deviceWidth * 0.09,),
                                ],
                              ),
                            ),
                            SizedBox(width: deviceWidth * 0.04,),
                            Expanded(
                              flex: 7,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  SizedBox(height: deviceWidth * 0.02,),
                                  Text(
                                    '${postusers[index+3]} ${messages[index]}',
                                    style: TextStyle(
                                      fontSize: deviceWidth * 0.041,
                                    ),
                                  ),
                                  SizedBox(height: deviceWidth * 0.06,),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.favorite_border_outlined,size: deviceWidth * 0.045,color: Colors.grey[500],),
                                      Text('      Reply',style: TextStyle(fontSize: deviceWidth * .034,color: Colors.grey[500]),),
                                    ],
                                  ),
                                  SizedBox(height: deviceWidth * 0.0,),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  Container(
                                    width: deviceWidth * 0.17,
                                    height: deviceWidth * 0.17,
                                    margin: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage("assets/avatar.png"),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: deviceWidth * .05,),
                                ],
                              ),
                            ),
                            SizedBox(width: deviceWidth * 0.01,),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            SliverList(delegate: SliverChildListDelegate(
              <Widget>[
                SizedBox(height: deviceWidth * .07,),
                Row(
                  children: <Widget>[
                    SizedBox(width: deviceWidth * 0.04,),
                    Text(
                      'This week',
                      style: TextStyle(
                        fontSize: deviceWidth * 0.05,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),),
            SliverList(
              delegate: SliverChildListDelegate(
                List.generate(
                  3,
                      (int index) {
                    return Column(
                      children: <Widget>[
                        SizedBox(height: deviceWidth * 0.06,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(width: deviceWidth * 0.04,),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: const AssetImage("assets/avatar.png"),
                                    radius: deviceWidth * 0.08,
                                  ),
                                  SizedBox(height: deviceWidth * 0.09,),
                                ],
                              ),
                            ),
                            SizedBox(width: deviceWidth * 0.04,),
                            Expanded(
                              flex: 7,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  SizedBox(height: deviceWidth * 0.02,),
                                  Text(
                                    '${postusers[index+6]} ${messages[index]}',
                                    style: TextStyle(
                                      fontSize: deviceWidth * 0.041,
                                    ),
                                  ),
                                  SizedBox(height: deviceWidth * 0.06,),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.favorite_border_outlined,size: deviceWidth * 0.045,color: Colors.grey[500],),
                                      Text('      Reply',style: TextStyle(fontSize: deviceWidth * .034,color: Colors.grey[500]),),
                                    ],
                                  ),
                                  SizedBox(height: deviceWidth * 0.0,),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  Container(
                                    width: deviceWidth * 0.17,
                                    height: deviceWidth * 0.17,
                                    margin: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage("assets/avatar.png"),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: deviceWidth * .05,),
                                ],
                              ),
                            ),
                            SizedBox(width: deviceWidth * 0.01,),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            SliverList(delegate: SliverChildListDelegate(
              <Widget>[
                SizedBox(height: deviceWidth * .07,),
                Row(
                  children: <Widget>[
                    SizedBox(width: deviceWidth * 0.04,),
                    Text(
                      'This Month',
                      style: TextStyle(
                        fontSize: deviceWidth * 0.05,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),),
            SliverList(
              delegate: SliverChildListDelegate(
                List.generate(
                  3,
                      (int index) {
                    return Column(
                      children: <Widget>[
                        SizedBox(height: deviceWidth * 0.06,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(width: deviceWidth * 0.04,),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: const AssetImage("assets/avatar.png"),
                                    radius: deviceWidth * 0.08,
                                  ),
                                  SizedBox(height: deviceWidth * 0.09,),
                                ],
                              ),
                            ),
                            SizedBox(width: deviceWidth * 0.04,),
                            Expanded(
                              flex: 7,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  SizedBox(height: deviceWidth * 0.02,),
                                  Text(
                                    '${postusers[index+9]} ${messages[index]}',
                                    style: TextStyle(
                                      fontSize: deviceWidth * 0.041,
                                    ),
                                  ),
                                  SizedBox(height: deviceWidth * 0.06,),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.favorite_border_outlined,size: deviceWidth * 0.045,color: Colors.grey[500],),
                                      Text('      Reply',style: TextStyle(fontSize: deviceWidth * .034,color: Colors.grey[500]),),
                                    ],
                                  ),
                                  SizedBox(height: deviceWidth * 0.0,),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  Container(
                                    width: deviceWidth * 0.17,
                                    height: deviceWidth * 0.17,
                                    margin: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage("assets/avatar.png"),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: deviceWidth * .05,),
                                ],
                              ),
                            ),
                            SizedBox(width: deviceWidth * 0.01,),
                          ],
                        ),
                      ],
                    );
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