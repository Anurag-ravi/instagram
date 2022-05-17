import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:instagram/data.dart';
import 'package:instagram/pages/login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key,required this.prefs}) : super(key: key);
  final SharedPreferences prefs;
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController password1Controller = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  int buttonColor = 0xff459EFF;

  bool _email_valid = true;
  bool _pass_valid = true;
  bool _pass_match = true;

  bool inputTextNotNull = false;
  String _email = '', _password1 = '', _password2 = '';

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
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
                    SizedBox(
                      height: deviceWidth * .1,
                    ),
                    Container(
                      width: deviceWidth * .90,
                      height: deviceWidth * .14,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Center(
                          child: TextField(
                            cursorColor: Colors.grey,
                            onChanged: (text) {
                              setState(() {
                                _email_valid = true;
                                _email = text.trim();
                                if (usernameController.text.length >= 2 &&
                                    password1Controller.text.length >= 2 &&
                                    password2Controller.text.length >= 2) {
                                  inputTextNotNull = true;
                                } else {
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
                    SizedBox(
                      height: deviceWidth * .04,
                    ),
                    Container(
                      width: deviceWidth * .90,
                      height: deviceWidth * .14,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Center(
                          child: TextField(
                            cursorColor: Colors.grey,
                            onChanged: (text) {
                              setState(() {
                                _pass_valid = true;
                                _pass_match = true;
                                _password1 = text.trim();
                                if (usernameController.text.length >= 2 &&
                                    password1Controller.text.length >= 2 &&
                                    password2Controller.text.length >= 2) {
                                  inputTextNotNull = true;
                                } else {
                                  inputTextNotNull = false;
                                }
                              });
                            },
                            controller: password1Controller,
                            obscureText: true,
                            style: TextStyle(
                              fontSize: deviceWidth * .040,
                            ),
                            decoration:  _pass_match ? _pass_valid ? const InputDecoration.collapsed(
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              )
                            ) : const InputDecoration(
                              errorText: 'Password must be more than 8 charachters long'
                            ) : const InputDecoration(
                              errorText: "The two passwords didn't matched"
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: deviceWidth * .04,
                    ),
                    Container(
                      width: deviceWidth * .90,
                      height: deviceWidth * .14,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Center(
                          child: TextField(
                            cursorColor: Colors.grey,
                            onChanged: (text) {
                              setState(() {
                                _pass_valid = true;
                                _pass_match = true;
                                _password2 = text.trim();
                                if (usernameController.text.length >= 2 &&
                                    password1Controller.text.length >= 2 &&
                                    password2Controller.text.length >= 2) {
                                  inputTextNotNull = true;
                                } else {
                                  inputTextNotNull = false;
                                }
                              });
                            },
                            controller: password2Controller,
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
                    SizedBox(
                      height: deviceWidth * .04,
                    ),
                    inputTextNotNull
                        ? GestureDetector(
                            onLongPressStart: (s) {
                              setState(() {
                                buttonColor = 0xff78C9FF;
                              });
                            },
                            onLongPressEnd: (s) {
                              setState(() {
                                buttonColor = 0xff459EFF;
                              });
                            },
                            onTap: () async {
                                signup(_email, _password1,_password2);
                            },
                            child: Container(
                              width: deviceWidth * .90,
                              height: deviceWidth * .14,
                              decoration: BoxDecoration(
                                color: Color(buttonColor),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Center(
                                child: Text(
                                  'Sign up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: deviceWidth * .040,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            width: deviceWidth * .90,
                            height: deviceWidth * .14,
                            decoration: const BoxDecoration(
                              color: Color(0xff78C9FF),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Center(
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: deviceWidth * .040,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: deviceWidth * .25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 1,
                          width: deviceWidth * .40,
                          color: const Color(0xffA2A2A2),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'OR',
                          style: TextStyle(
                            fontSize: deviceWidth * .040,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 1,
                          width: deviceWidth * .40,
                          color: const Color(0xffA2A2A2),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: deviceWidth * .06,
                    ),
                  ],
                ),
                Container(
                  width: deviceWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Have an account? ",
                            style: TextStyle(
                              fontSize: deviceWidth * .040,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (builder)=> Login(prefs: widget.prefs,)));
                            },
                            child: Text(
                              'Log in',
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

  signup(String _email, String _password1, String _password2) async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _email_valid = isValidEmail(_email);
      _pass_match = _password1 == _password2;
      _pass_valid = isValidPass(_password1);
    });
    if (_email_valid && _pass_valid){
      final response = await http.post(
        Uri.parse("${url}user/register/"),
        body: jsonEncode({
          "email": _email,
          "password": _password1
        })
      );
      var data = jsonDecode(response.body);
      if(response.statusCode == 201){
        Navigator.push(context, MaterialPageRoute(builder: (builder) => Login(prefs: widget.prefs,)));
        var snackBar = SnackBar(
        content: Text(data['message']),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      var snackBar = SnackBar(
      content: Text(data['message']),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
