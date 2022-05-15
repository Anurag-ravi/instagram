import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/components/followCard.dart';
import 'package:instagram/components/highlightcard.dart';
import 'package:instagram/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool verified = false;
  bool posts = true;
  final controller = PageController(initialPage:0);

  bool isvisible = false;
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff8faf8),
        elevation: 0.0,
        centerTitle: false,
        title: SizedBox(
          height: deviceWidth * 0.12,
          child: Column(
            children: [
              SizedBox(
                height: deviceWidth * .02,
              ),
              Row(
                children: [
                  const Text(
                    'anu.rag__r',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'arial',
                    ),
                  ),
                  verified
                      ? Icon(
                          Icons.check_circle_rounded,
                          color: Colors.blue,
                          size: deviceWidth * 0.06,
                        )
                      : Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                          size: deviceWidth * 0.07,
                        ),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () { },
              alignment: Alignment.center,
              icon: SvgPicture.asset('assets/add.svg',
                  height: deviceWidth * 0.09)
              ),
          IconButton(
            onPressed: () {
              bottompopup(context);
            },
            alignment: Alignment.center,
            icon: Icon(
              Icons.menu_outlined,
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
                  children: [
                    SizedBox(
                      width: deviceWidth * 0.045,
                    ),
                    SizedBox(
                      height: deviceWidth * .26,
                    ),
                    CircleAvatar(
                      backgroundImage: const AssetImage('assets/avatar.png'),
                      radius: deviceWidth * 0.12,
                    ),
                    SizedBox(
                      width: deviceWidth * .1,
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          '5',
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
                    SizedBox(
                      width: deviceWidth * .04,
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          '500',
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
                    SizedBox(
                      width: deviceWidth * .04,
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          '496',
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
                      'Anurag Ravi',
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
                        'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiioooooooooooooooooooooooooooooooooooooooooooooo',
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
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: deviceWidth * 0.03,
                    ),
                    GestureDetector(
                      // onTap: () =>
                      //     Navigator.pushNamed(context, '/editprofile'),
                      child: Container(
                        width: deviceWidth * .81,
                        height: deviceWidth * .11,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(7)),
                        ),
                        child: Center(
                          child: Text(
                            'Edit Profile',
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
                      onTap: () {
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(7)),
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
                        height: deviceWidth * 0.55,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                            17,
                            (int index) {
                              return FollowCard();
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
                    padding:
                        EdgeInsets.symmetric(horizontal: deviceWidth * 0.02),
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
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), 
                        itemCount: 10,
                        itemBuilder: (context,index) {
                          return Padding(
                            padding: const EdgeInsets.all(1),
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Image.asset('assets/post0.jpeg',fit: BoxFit.cover,),
                              ),
                          );
                        }
                        ,),
                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), 
                    itemCount: 5,
                    itemBuilder: (context,index) {
                      return AspectRatio(
                            aspectRatio: 1 / 1,
                            child: Image.asset('assets/post0.jpeg',fit: BoxFit.cover,),
                            );
                    }
                    ,)
                    ],
                  ),
                ),
              ],
        ),
          
      );
  }
}

void bottompopup(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height * .33,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                
                SizedBox(
                  height: MediaQuery.of(context).size.height * .03,
                ),
                GestureDetector(
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.remove('token');
                    const snackBar = SnackBar(
                    content: Text('Succcessfully Logged out'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const Login(),));
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.0205,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.0215,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .04,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Mute Messages',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.0215,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .04,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Mute Call Notifications',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.0215,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
