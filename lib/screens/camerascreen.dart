import 'package:flutter/material.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return const Scaffold(
      body: Center(
        child: Text('camera screen'),
      ),
    );
  }
}