import 'package:flutter/material.dart';

class DmScreen extends StatefulWidget {
  const DmScreen({ Key? key }) : super(key: key);

  @override
  State<DmScreen> createState() => _DmScreenState();
}

class _DmScreenState extends State<DmScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('dm screen'),
      ),
    );
  }
}