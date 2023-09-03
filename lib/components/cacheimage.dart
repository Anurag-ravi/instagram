import 'dart:convert';
// import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChachedImage extends StatelessWidget {
  const ChachedImage({ Key? key, required this.url,this.bytes="",this.ratio = 1.0,required this.prefs }) : super(key: key);
  final String url;
  final String bytes;
  final double ratio;
  final SharedPreferences prefs;
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double h = deviceWidth * ratio;
    Image img = Image.memory(base64Decode(bytes),width: deviceWidth,);
    String media = prefs.getString('media')!;
    return CachedNetworkImage(
        imageUrl: media + url,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            Stack(
              alignment: Alignment.center,
              children: [
                bytes.length > 0 ? 
                Container(
                  width: deviceWidth,
                  height: h,
                  decoration: BoxDecoration(image: DecorationImage(
                    fit: BoxFit.fill,
                    image: img.image
                  ),
                  ),
                ) 
                : Container(),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white70,
                    backgroundColor: Colors.white60,
                    value: downloadProgress.progress,
                    valueColor: const AlwaysStoppedAnimation(Colors.grey),
                    ),
                )
              ],
            ),
        errorWidget: (context, url, error) => const Icon(
          Icons.error,
          color: Colors.red,
        ));
  }
}