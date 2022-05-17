import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:instagram/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

logout(context) async {
  SharedPreferences prefs =
      await SharedPreferences.getInstance();
  prefs.remove('token');
  const snackBar = SnackBar(
    content: Text('Succcessfully Logged out'),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (BuildContext context) => Login(prefs: prefs,),
  ));
}

settoken(Response response) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = response.headers['jwt'];
        prefs.setString('token', token!);
}

Future<bool> internetAvailable() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  return false;
}


