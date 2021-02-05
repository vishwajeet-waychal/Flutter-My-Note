import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_app/authentication/forgot_password_ui.dart';
import 'package:notes_app/authentication/sign_up_ui.dart';
import 'package:notes_app/helper/constants.dart';
import 'package:notes_app/helper/helperfunctions.dart';
import 'package:notes_app/screen_transition/page_transition_effect.dart';
import 'package:notes_app/screens/home_page.dart';
import 'package:notes_app/services/auth.dart';
import 'package:notes_app/services/database.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool _obscureText = true;
  bool _emailFieldError = false;
  bool _passwordFieldError = false;
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot snapshotUserInfo;
  bool isLoading = false;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  getUserData() async {
    databaseMethods.getUserByUserEmail(emailTextEditingController.text).then((val) {
      snapshotUserInfo = val;
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      Constants.current_user_emailID = emailTextEditingController.text;
    });
  }

  _login() {
    if(emailTextEditingController.text == null || emailTextEditingController.text.length == 0) {
      setState(() {
        _emailFieldError = true;
      });
    }
    if(passwordTextEditingController.text == null || passwordTextEditingController.text.length == 0) {
      setState(() {
        _passwordFieldError = true;
      });
    }

    if(!_emailFieldError && !_passwordFieldError) {
      setState(() {
        isLoading = true;
      });
      getUserData();
      authMethods.signInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val) {
        if(val != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);

          Fluttertoast.showToast(
            msg: "Login Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Colors.blue,
            fontSize: 16.0,
          );

          Navigator.of(context).pop();
          //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
          Navigator.push(context, FadeRoute(page: HomePage()));
        } else {
          setState(() {
            isLoading = false;
            Fluttertoast.showToast(
              msg: "User not found",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.white,
              textColor: Colors.blue,
              fontSize: 16.0,
            );
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF013a63),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome",
                      style: GoogleFonts.syncopate(
                        textStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.white
                        ),
                      )
                    ),
                    Text(
                      "Login",
                      style: GoogleFonts.michroma(
                        textStyle: TextStyle(
                            fontSize: 35,
                            color: Colors.white
                        ),
                      )
                      )
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3f000000),
                    blurRadius: 50,
                    offset: Offset(16, 10),
                  ),
                ],
                color: Colors.white,
              ),
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                  return true;
                },
                child: ListView(
                  children: [
                    Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          child: Column(
                            children: [
                              TextFormField(
                                onChanged: (value) {
                                  if(value.isNotEmpty) {
                                    setState(() {
                                      _emailFieldError = false;
                                    });
                                  }
                                },
                                controller: emailTextEditingController,
                                style: GoogleFonts.quicksand(),
                                decoration: InputDecoration(
                                    errorText: _emailFieldError ? 'This field is required' : null,
                                    icon: Icon(FontAwesomeIcons.userAlt,),
                                    border: InputBorder.none,
                                    labelText: 'EMAIL'
                                ),
                              ),
                              Divider(),
                              TextFormField(
                                onChanged: (value) {
                                  if(value.isNotEmpty) {
                                    setState(() {
                                      _passwordFieldError = false;
                                    });
                                  }
                                },
                                controller: passwordTextEditingController,
                                obscureText: _obscureText,
                                style: GoogleFonts.quicksand(),
                                decoration: InputDecoration(
                                    errorText: _passwordFieldError ? 'This field is required' : null,
                                    icon: Icon(FontAwesomeIcons.lock,),
                                    suffixIcon: InkWell(
                                      child: _obscureText ? Icon(FontAwesomeIcons.eye,) : Icon(FontAwesomeIcons.eyeSlash,),
                                      onTap: () {
                                        _toggle();
                                      },
                                    ),
                                    border: InputBorder.none,
                                    labelText: 'PASSWORD'
                                ),
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    child: Container(
                                      height: 45,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: isLoading ? Container(
                                            alignment: Alignment.center,
                                            child: Lottie.asset('assets/lottie/loading.json')
                                        ) : Text(
                                            "Login",
                                            style: GoogleFonts.telex(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18
                                              ),
                                            )
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Color(0xFF013a63)
                                      ),
                                    ),
                                    onTap: () {
                                      _login();
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              InkWell(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "Sign up",
                                        style: GoogleFonts.telex(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18
                                          ),
                                        )
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0xFF013a63)
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(context, FadeRoute(page: SignUp()));
                                },
                              ),
                              SizedBox(height: 10,),
                              InkWell(
                                child: Text(
                                    "Forgot Password",
                                    style: GoogleFonts.telex(
                                      textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue
                                      ),
                                    )
                                ),
                                onTap: () {
                                  Navigator.push(context, FadeRoute(page: ForgotPassword()));
                                },
                              ),
                            ],
                          )
                      )
                    ],
                  ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
