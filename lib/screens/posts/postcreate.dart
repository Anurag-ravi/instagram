import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/components/cacheimage.dart';
import 'package:instagram/screens/feedscreen.dart';
import 'package:instagram/utilities/constants.dart';
import 'package:instagram/utilities/logout.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;


class  PostCreate extends StatefulWidget {
  const PostCreate({ Key? key,this.updating = false,this.url = '',this.id = 0,this.caption = '',this.location = '' }) : super(key: key);
  final bool updating;
  final String url;
  final int id;
  final String caption;
  final String location;

  @override
  State<PostCreate> createState() => _PostCreateState();
}

class _PostCreateState extends State<PostCreate> { 
  final _controller = PageController(initialPage: 1);
  late SharedPreferences prefs;
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  bool imagepicked = false;
  File _pickedimg = File('');
  Uint8List webimage = Uint8List(0);
  bool uploading = false;

  @override
  void initState() {
    // TODO: implement initState
    init();
    if(widget.updating){
      captionController.text = widget.caption;
      locationController.text = widget.location;
    }
    super.initState();
  }

  init() async {
    SharedPreferences temp = await SharedPreferences.getInstance();
    setState(() {
      prefs = temp;
    });
  }

  Future<int> createpost() async {
    FocusManager.instance.primaryFocus!.unfocus();
    setState(() {
      uploading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? url = prefs.getString('url');
    var request = http.MultipartRequest(
        'POST', Uri.parse("${url!}post/new/"),
    );
    Map<String,String> headers={
      "Authorization": token!
      // "Content-type": "multipart/form-data"
    };
    if(!kIsWeb){
      var stream = http.ByteStream(_pickedimg.openRead());
      stream.cast();
      var length = await _pickedimg.length();
      request.files.add(
          http.MultipartFile(
            'image',
            stream,
            length,
            filename: basename(_pickedimg.path)
          ),
      );
    } else {
      request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            webimage,
            filename: 'post.jpg'
          ),
      );
    }
    request.headers.addAll(headers);
    request.fields.addAll({
      "creator":prefs.getInt('id')!.toString(),
      "caption":captionController.text,
      "location":locationController.text
    });
    var res = await request.send();
    setState(() {
      uploading = false;
    });
    return res.statusCode;
  }

  Future<int> update() async {
    FocusManager.instance.primaryFocus!.unfocus();
    String? token = prefs.getString('token');
    String? url = prefs.getString('url');
    final response = await http.put(
      Uri.parse("${url!}post/edit/${widget.id}/"),
      headers: <String, String>{
        'Authorization': token!,
        "Content-type": "application/json"
        },
      body: jsonEncode({
        "caption":captionController.text,
        "location":locationController.text
        })
    );
    if (response.statusCode == 201) {
      return 201;
    }
    
    const snackBar = SnackBar(
      content: Text('Some Error occured 🥲'),
    );
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
    return 400;
  }


  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xfff8faf8),
              elevation: 0.5,
              centerTitle: false,
              title: Text(
                widget.updating ? 'Update Post' : 'Create Post',
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
                  onPressed: () async{
                    if(widget.updating){
                      int code = await update();
                      code == 201 ? Navigator.push(context, MaterialPageRoute(builder: (builder)=>FeedScreen(controller: _controller, prefs: prefs,tab: 0,))) : null;
                      const snackBar = SnackBar(
                        content: Text('Post Updated 😊'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    if(imagepicked && !widget.updating){
                      int code = await createpost();
                      if(code == 201){
                        Navigator.push(context, MaterialPageRoute(builder: (builder)=>FeedScreen(controller: _controller, prefs: prefs,tab: 0,)));
                        const snackBar = SnackBar(
                        content: Text('Post Created 😍'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      const snackBar = SnackBar(
                      content: Text('Some error occured 🥲'),
                      );
                      code != 201 ? ScaffoldMessenger.of(context).showSnackBar(snackBar) : null;
                    }
                    const snackBar = SnackBar(
                      content: Text('Please pich one image'),
                      );
                      !widget.updating && !imagepicked ? ScaffoldMessenger.of(context).showSnackBar(snackBar) : null;
                  },
                  icon: const Icon(
                    Icons.check,
                    color: Colors.blue,
                  ),
                ),
              ],
          ),
          body: ListView(
            children: [
              SizedBox(
                height: deviceWidth * .01,
              ),
              Container(
                width: deviceWidth,
                height: deviceWidth,
                color: imagepicked ? Colors.white : Colors.grey[300],
                child: AspectRatio(
                  aspectRatio: 1/1,
                  child: widget.updating ? ChachedImage(url: widget.url,prefs: prefs,) : imagepicked ? kIsWeb ? Image.memory(webimage) : Image.file(_pickedimg) : const Icon(Icons.image_outlined),
                  ),
              ),
              SizedBox(
                height: deviceWidth * .03,
              ),
              !widget.updating ? GestureDetector(
                onTap: () => pickImage(context),
                child: Center(
                  child: Text('Change Photo',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: deviceWidth *.05,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ) : Container(),
              SizedBox(
                height: deviceWidth*.05,
              ),
              Row(
                children: [
                  SizedBox(
                    width: deviceWidth*.05,
                  ),
                  Text('Caption',
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
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    child: Center(
                        child: TextFormField(
                          cursorColor: Colors.grey,
                          controller: captionController,
                          style: TextStyle(
                            fontSize: deviceWidth * .045,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Write a Caption...',
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
                  Text('Location',
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
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    child: Center(
                        child: TextFormField(
                          cursorColor: Colors.grey,
                          controller: locationController,
                          style: TextStyle(
                            fontSize: deviceWidth * .045,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Add a Location....',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        uploading ? Scaffold(backgroundColor: Colors.black.withOpacity(0.5),body: Center(child: CircularProgressIndicator(),),) : Container()
      ],
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
          imagepicked = true;
        });
      } else {
        var f = await image!.readAsBytes();
        setState(() {
          _pickedimg = File("a");
          webimage = f;
          imagepicked = true;
        });
      }
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('We are sorry, but you can\'t pick an image in this device.\ntry the same in android app or web')));
      return;
    }
  }
}