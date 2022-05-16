import 'package:flutter/material.dart';
import 'package:instagram/pages/home.dart';
import 'package:instagram/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
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
      home: prefs.getString('token') == null ? const Login() : const HomePage()
    );
  }
}

