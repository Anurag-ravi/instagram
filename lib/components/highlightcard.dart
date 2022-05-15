import 'package:flutter/material.dart';

class HighlightCard extends StatelessWidget {
  const HighlightCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.02),
      child: Column(
        children: [
          Stack(
            alignment: const Alignment(0, 0),
            children: <Widget>[
              Container(
                width: deviceWidth * 0.20,
                height: deviceWidth * 0.20,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.purpleAccent, Colors.orange])),
              ),
              Container(
                width: deviceWidth * 0.19,
                height: deviceWidth * 0.19,
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                ),
              ),
              Container(
                width: deviceWidth * 0.17,
                height: deviceWidth * 0.17,
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
          Text(
            'hhhhhhh',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: deviceWidth * 0.03),
          ),
        ],
      ),
    );
  }
}
