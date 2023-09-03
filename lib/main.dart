// import 'dart:io';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:instagram/pages/home.dart';
import 'package:instagram/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import 'package:window_size/window_size.dart';

late SharedPreferences prefs;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  // if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
  //   setWindowTitle("Anurag's Instagram");
  //   setWindowMaxSize(const Size(350, 720));
  //   setWindowMinSize(const Size(350, 720));
  // }
  // Run the HTTP request in the background
  _performBackgroundTask(prefs);
  runApp(const MyApp());
}

void _performBackgroundTask(SharedPreferences prefs) async {
  // Make an HTTP request and process the response
  prefs.setString('url', "https://ibackend.cseiitg.tech/");
  prefs.setString('media', "https://ibackend.cseiitg.tech");
  final response = await http.get(Uri.parse('https://url-resolver-79q4.onrender.com/insta_backend'));
  if (response.statusCode == 200) {
    String url = JsonDecoder().convert(response.body)['url'];
    prefs.setString('url', url+'/');
    prefs.setString('media', url);
  } else {
    print('Failed to fetch data from the server.');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram',
      theme: ThemeData(
        // fontFamily: "OpenSans",
        bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.transparent),
        colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.black,
            primary: Colors.white,
      ),),
      debugShowCheckedModeBanner: false,
      home: prefs.getString('token') == null ? Login(prefs: prefs,) : HomePage(prefs: prefs,)
    );
  }
}

