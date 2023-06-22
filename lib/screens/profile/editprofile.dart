// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/components/cacheimage.dart';
import 'package:instagram/models/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/screens/feedscreen.dart';
import 'package:instagram/utilities/logout.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class EditProfile extends StatefulWidget {
  const EditProfile({ Key? key,required this.profile }) : super(key: key);
  final ProfileModel profile;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  String profileurl = '';
  File _pickedimg = File('');
  bool imgpicked = false;
  Uint8List webimage = Uint8List(0);
  bool usernamevalid = true;
  late SharedPreferences prefs;

  @override
  void initState() {
    init();
    // TODO: implement initState
    nameController.text = widget.profile.name;
    usernameController.text = widget.profile.username;
    bioController.text = widget.profile.bio;
    profileurl = widget.profile.dp;
    super.initState();
  }

  init() async {
    SharedPreferences temp = await SharedPreferences.getInstance();
    setState(() {
      prefs = temp;
    });
  }

  Future<void> checkusername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? url = prefs.getString('url');
      final response = await http.post(Uri.parse("${url!}user/check_username/"),
          headers: <String, String>{'Authorization': token!},
          body: jsonEncode({"username": usernameController.text}));
      if (response.statusCode == 200) {
        setState(() {
          usernamevalid = true;
        });
        return;
      }
      if (response.statusCode == 400) {
        setState(() {
          usernamevalid = false;
        });
        return;
      }
      if (response.statusCode == 401) {
        logout(context);
        return;
      }
  }

  Future<int> editProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? url = prefs.getString('url');
    var request = http.MultipartRequest(
        'PUT', Uri.parse("${url!}user/update_profile/"),

    );
    Map<String,String> headers={
      "Authorization": token!
      // "Content-type": "multipart/form-data"
    };
    if(imgpicked){
      if(!kIsWeb){
        var stream = http.ByteStream(_pickedimg.openRead());
        stream.cast();
        var length = await _pickedimg.length();
        request.files.add(
            http.MultipartFile(
              'dp',
                stream,
                length,
                filename: basename(_pickedimg.path)
            ),
        );
      } else {
        request.files.add(
            http.MultipartFile.fromBytes(
            'dp',
            webimage,
            filename: 'dp.jpg'
          ),
        );
      }
    }
    request.headers.addAll(headers);
    request.fields.addAll({
      "name":nameController.text,
      "username":usernameController.text,
      "bio":bioController.text
    });
    var res = await request.send();
    return res.statusCode;
  }

  
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: new Color(0xfff8faf8),
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          alignment: Alignment.centerLeft,
          icon: Icon(
            Icons.clear_outlined,
            color: Colors.black,
            size: deviceWidth * 0.08,
          ),
        ),
        title: SizedBox(
          height: deviceWidth * 0.12,
          child: Column(
            children: [
              SizedBox(height: deviceWidth * .02,),
              Row(
                children: const [
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'arial',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              if(usernamevalid){
                int code = await editProfile();
                if (code == 200){
                  PageController controller = PageController(initialPage: 1);
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>FeedScreen(controller: controller, prefs: prefs,tab: 4,)));
                }
                if (code == 400){
                  const snackBar = SnackBar(
                  content: Text('Try Again....'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              } else {
                const snackBar = SnackBar(
                  content: Text('Try with valid username'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            alignment: Alignment.center,
            icon: Icon(
              Icons.check,
              color: Colors.blue,
              size: deviceWidth * 0.09,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                SizedBox(
                  height: deviceWidth * .01,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: deviceWidth * 0.30,
                    ),
                    Column(
                      children: [
                        imgpicked ? ClipOval(
                          child: Container(
                            width: deviceWidth * 0.4,
                            height: deviceWidth * 0.4,
                            child: kIsWeb ? Image.memory(webimage) : Image.file(_pickedimg)
                          ),
                        ) 
                        : ClipOval(
                          child: Container(
                            width: deviceWidth * 0.4,
                            height: deviceWidth * 0.4,
                            child: profileurl == '' ? Image.asset('assets/avatar.png') : ChachedImage(url: profileurl,prefs:prefs,),
                          ),
                        ),
                        SizedBox(
                          height: deviceWidth*.03,
                        ),
                        GestureDetector(
                          onTap: () => pickImage(context),
                          child: Text('Change Photo',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: deviceWidth *.055,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: deviceWidth*.05,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: deviceWidth*.05,
                    ),
                    Text('Name',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: deviceWidth *.045,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: deviceWidth*.015,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: deviceWidth*.05,
                    ),
                    Container(
                      width: deviceWidth * .90,
                      height: deviceWidth * .1,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      child: Center(
                          child: TextFormField(
                            cursorColor: Colors.grey,
                            controller: nameController,
                            style: TextStyle(
                              fontSize: deviceWidth * .045,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration.collapsed(
                              hintText: 'Name',
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: deviceWidth*.05,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: deviceWidth*.05,
                    ),
                    Text( usernamevalid ? 'Username' : 'Username : this username is taken',
                      style: TextStyle(
                        color: usernamevalid ? Colors.grey : Colors.red,
                        fontSize: usernamevalid ? deviceWidth *.045 : deviceWidth * 0.035,
                        fontWeight: usernamevalid ? FontWeight.w400 : null,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: deviceWidth*.015,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: deviceWidth*.05,
                    ),
                    Container(
                      width: deviceWidth * .90,
                      height: deviceWidth * .1,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      child: Center(
                        child: TextField(
                          onChanged: (text){
                            checkusername() ;
                          },
                          cursorColor: Colors.grey,
                          controller: usernameController,
                          style: TextStyle(
                            fontSize: deviceWidth * .045,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration.collapsed(
                            hintText: 'username',

                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: deviceWidth*.05,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: deviceWidth*.05,
                    ),
                    Text('Bio',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: deviceWidth *.045,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: deviceWidth*.015,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: deviceWidth*.05,
                    ),
                    Container(
                      width: deviceWidth * .90,
                      height: deviceWidth * .1,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      child: Center(
                        child: TextFormField(
                          cursorColor: Colors.grey,
                          controller: bioController,
                          style: TextStyle(
                            fontSize: deviceWidth * .045,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration.collapsed(
                            hintText: 'bio',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  pickImage(context) async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      final _picker = ImagePicker();
      var image = await _picker.pickImage(source: ImageSource.gallery);
      if(!kIsWeb){
        setState(() {
          _pickedimg = File(image!.path);
          imgpicked = true;
        });
      } else {
        var f = await image!.readAsBytes();
        setState(() {
          _pickedimg = File("a");
          webimage = f;
          imgpicked = true;
        });
      }
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('We are sorry, but you can\'t pick an image in this device.\ntry the same in android app or web')));
      return;
    }
  }
}