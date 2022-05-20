import 'package:flutter/material.dart';

class PostCreate extends StatefulWidget {
  const PostCreate({ Key? key }) : super(key: key);

  @override
  State<PostCreate> createState() => _PostCreateState();
}

class _PostCreateState extends State<PostCreate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('post create'),
    );
  }
}