import 'package:flutter/material.dart';

class StoryCard extends StatelessWidget {
  const StoryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(9),
          child: Stack(
            alignment: const Alignment(0, 0),
            children: <Widget>[
              Container(
                width: deviceWidth * 0.224,
                height: deviceWidth * 0.224,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.purpleAccent, Colors.orange])),
              ),
              Container(
                width: deviceWidth * 0.21,
                height: deviceWidth * 0.21,
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                ),
              ),
              Container(
                width: deviceWidth * 0.195,
                height: deviceWidth * 0.195,
                child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/avatar.png')),
              ),
              FloatingActionButton(
                onPressed: () {},
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ],
          ),
        ),
        Text(
          'Your Story',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: deviceWidth * 0.03),
        ),
      ],
    );
  }
}
