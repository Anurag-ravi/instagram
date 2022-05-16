import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram/data.dart';

class ChachedImage extends StatelessWidget {
  const ChachedImage({ Key? key, required this.url }) : super(key: key);
  final String url;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: media + url,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white70,
                backgroundColor: Colors.white60,
                value: downloadProgress.progress,
                valueColor: const AlwaysStoppedAnimation(Colors.grey),
                ),
            ),
        errorWidget: (context, url, error) => const Icon(
          Icons.error,
          color: Colors.red,
        ));
  }
}