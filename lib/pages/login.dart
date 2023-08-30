// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:instagram/pages/forgot_pass.dart';
import 'package:instagram/pages/home.dart';
import 'package:instagram/pages/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({ Key? key ,required this.prefs}) : super(key: key);
  final SharedPreferences prefs;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  int buttonColor = 0xff459EFF;

  bool inputTextNotNull = false;
  bool _email_valid = true;
  bool _pass_valid = true;
  String _email='', _password='';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 90,
          ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/instagram_logo.png',
                      height: deviceWidth * .17,
                    ),
                    SizedBox(height: deviceWidth * .1,),
                    Container(
                      width: deviceWidth * .90,
                      height: deviceWidth * .14,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Center(
                          child: TextField(
                            cursorColor: Colors.grey,
                            onChanged: (text){
                              setState(() {
                                _email_valid = true;
                                _email=text.trim();
                                if(usernameController.text.length >= 2 && passwordController.text.length >= 2){
                                  inputTextNotNull = true;
                                }else{
                                  inputTextNotNull = false;
                                }
                              });
                            },
                            controller: usernameController,
                            style: TextStyle(
                              fontSize: deviceWidth * .040,
                            ),
                            decoration:  _email_valid ? const InputDecoration.collapsed(
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              )
                            ) : const InputDecoration(
                              errorText: 'Please Enter a valid Email'
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: deviceWidth * .04,),
                    Container(
                      width: deviceWidth * .90,
                      height: deviceWidth * .14,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Center(
                          child: TextField(
                            cursorColor: Colors.grey,
                            onChanged: (text){
                              setState(() {
                                _pass_valid = true;
                                _password=text.trim();
                                if(usernameController.text.length >= 2 && passwordController.text.length >= 2){
                                  inputTextNotNull = true;
                                }else{
                                  inputTextNotNull = false;
                                }
                              });
                            },
                            controller: passwordController,
                            obscureText: true,
                            style: TextStyle(
                              fontSize: deviceWidth * .040,
                            ),
                            decoration:  _pass_valid ? const InputDecoration.collapsed(
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              )
                            ) : const InputDecoration(
                              errorText: 'Password must be more than 8 charachters long'
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: deviceWidth * .04,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (builder)=> Forgot_Password(prefs: widget.prefs,)));
                          },
                          child: Text('Forgot password?      ',
                            style: TextStyle(
                              fontSize: deviceWidth * .035,
                              color: Colors.blue[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: deviceWidth * .035,),
                    inputTextNotNull?
                    GestureDetector(
                      onLongPressStart: (s){
                        setState(() {
                          buttonColor = 0xff78C9FF;
                        });
                      },
                      onLongPressEnd: (s){
                        setState(() {
                          buttonColor = 0xff459EFF;
                        });
                      },
                      onTap: () => {
                        login(_email, _password)
                        },
                      child: Container(
                        width: deviceWidth * .90,
                        height: deviceWidth * .14,
                        decoration: BoxDecoration(
                          color: Color(buttonColor),
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                        ),
                        child: loading ? Center(
                        child: SizedBox(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                          height: deviceWidth * 0.08,
                          width: deviceWidth * 0.08,
                        ),
                      ) : Center(
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: deviceWidth * .040,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ):
                    Container(
                      width: deviceWidth * .90,
                      height: deviceWidth * .14,
                      decoration: const BoxDecoration(
                        color: Color(0xff78C9FF),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Center(
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: deviceWidth * .040,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),


                    SizedBox(height: deviceWidth * .25,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 1,
                          width: deviceWidth * .40,
                          color: const Color(0xffA2A2A2),
                        ),
                        const SizedBox(width: 10,),
                        Text('OR',
                          style: TextStyle(
                            fontSize: deviceWidth * .040,
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Container(
                          height: 1,
                          width: deviceWidth * .40,
                          color: const Color(0xffA2A2A2),
                        ),
                      ],
                    ),
                    SizedBox(height: deviceWidth * .06,),

                  ],
                ),
                Container(
                  width: deviceWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      const SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account? ",
                            style: TextStyle(
                              fontSize: deviceWidth * .040,
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (builder)=> Signup(prefs: widget.prefs,)));
                            },
                            child: Text('Sign up',
                              style: TextStyle(
                                color: const Color(0xff459EFF),
                                fontSize: deviceWidth * .040,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  login(String _email,String _password) async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _email_valid = isValidEmail(_email);
      _pass_valid = isValidPass(_password);
      loading = true;
    });
    if (_email_valid && _pass_valid){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? url = prefs.getString('url');
      final response = await http.post(
        Uri.parse("${url!}user/login/"),
        headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "email": _email,
          "password": _password
        })
      );
      var data = jsonDecode(response.body);
      if(response.statusCode == 200){
        widget.prefs.setString('token', data['jwt']);
        widget.prefs.setString('username', data['username']);
        widget.prefs.setInt('id', data['id']);
        widget.prefs.setString('dp', data['dp']);
        const snackBar = SnackBar(
        content: Text('Succcessfully Logged in'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.push(context, MaterialPageRoute(builder: (builder) => HomePage(prefs: widget.prefs,)));
        setState(() {
          loading = false;
        });
        return;
      }
      var snackBar = SnackBar(
      content: Text(data['message']),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        loading = false;
      });
    }
  }

  bool isValidEmail(_email) {
      return RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(_email);
    }
  bool isValidPass(String _password) {
      return _password.length >= 8;
    }
}
