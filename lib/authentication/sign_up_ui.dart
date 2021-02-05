import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_app/authentication/sign_in_ui.dart';
import 'package:notes_app/helper/helperfunctions.dart';
import 'package:notes_app/services/auth.dart';
import 'package:notes_app/services/database.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool _firstNameFieldError = false;
  bool _lastNameFieldError = false;
  bool _emailFieldError = false;
  bool _passwordFieldError = false;
  bool _conformPasswordFieldError = false;
  bool _passwordMatch = false;
  bool isLoading = false;
  TextEditingController firstNameTextEditingController = TextEditingController();
  TextEditingController lastNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController conformPasswordTextEditingController = TextEditingController();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();


  _singUp() async {
    if(firstNameTextEditingController.text == null || firstNameTextEditingController.text.length == 0) {
      setState(() {
        _firstNameFieldError = true;
      });
    }

    if(lastNameTextEditingController.text == null || lastNameTextEditingController.text.length == 0) {
      setState(() {
        _lastNameFieldError = true;
      });
    }

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

    if(conformPasswordTextEditingController.text == null || conformPasswordTextEditingController.text.length == 0) {
      setState(() {
        _conformPasswordFieldError = true;
      });
    }

    if(!_passwordFieldError && !_conformPasswordFieldError) {
      if(passwordTextEditingController.text == conformPasswordTextEditingController.text) {
        setState(() {
          _passwordMatch = true;
        });
      } else {
        Fluttertoast.showToast(
          msg: "Password doesn't match",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Colors.blue,
          fontSize: 16.0,
        );
      }
    }

    if(!_firstNameFieldError && !_lastNameFieldError && !_emailFieldError && !_passwordFieldError && !_conformPasswordFieldError && _passwordMatch) {
      String fullName = firstNameTextEditingController.text + " " + lastNameTextEditingController.text;

      Map<String, String> userInfoMap = {
        "name" : fullName,
        "email" : emailTextEditingController.text,
        "first_name" : firstNameTextEditingController.text,
        "last_name" : lastNameTextEditingController.text,
        "userID" : "",
      };

      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);

      setState(() {
        isLoading = true;
      });

      authMethods.signUpwithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val) {
        databaseMethods.uploadUserInfo(userInfoMap);
        Navigator.of(context).pushNamedAndRemoveUntil('/AuthScreen', (Route<dynamic> route) => false);
        Fluttertoast.showToast(
          msg: "Account is created",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Colors.blue,
          fontSize: 16.0,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF013a63),
      body: isLoading ? Container(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                    alignment: Alignment.center,
                    child: Lottie.asset('assets/lottie/triangle-loading.json')
                ),
              ),
            ],
          ),
        ),
      ) : SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return true;
          },
          child: ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                        "Sign up",
                        style: GoogleFonts.michroma(
                          textStyle: TextStyle(
                              fontSize: 35,
                              color: Colors.white
                          ),
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        TextFormField(
                          onChanged: (value) {
                            if(value.isNotEmpty) {
                              setState(() {
                                _firstNameFieldError = false;
                              });
                            }
                          },
                          controller: firstNameTextEditingController,
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  color: Colors.white
                              )
                          ),
                          decoration: InputDecoration(
                              errorText: _firstNameFieldError ? 'This field is required' : null,
                              icon: Icon(FontAwesomeIcons.userAlt, color: Colors.white,),
                              border: InputBorder.none,
                              labelText: 'FIRST NAME',
                              labelStyle: TextStyle(
                                  color: Colors.white
                              )
                          ),
                        ),
                        Divider(color: Colors.white,),
                        TextFormField(
                          onChanged: (value) {
                            if(value.isNotEmpty) {
                              setState(() {
                                _lastNameFieldError = false;
                              });
                            }
                          },
                          controller: lastNameTextEditingController,
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  color: Colors.white
                              )
                          ),
                          decoration: InputDecoration(
                              errorText: _lastNameFieldError ? 'This field is required' : null,
                              icon: Icon(FontAwesomeIcons.userAlt, color: Colors.white,),
                              border: InputBorder.none,
                              labelText: 'LAST NAME',
                              labelStyle: TextStyle(
                                  color: Colors.white
                              )
                          ),
                        ),
                        Divider(color: Colors.white,),
                        TextFormField(
                          onChanged: (value) {
                            if(value.isNotEmpty) {
                              setState(() {
                                _emailFieldError = false;
                              });
                            }
                          },
                          controller: emailTextEditingController,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  color: Colors.white
                              )
                          ),
                          decoration: InputDecoration(
                              errorText: _emailFieldError ? 'This field is required' : null,
                              icon: Icon(FontAwesomeIcons.userAlt, color: Colors.white,),
                              border: InputBorder.none,
                              labelText: 'EMAIL',
                              labelStyle: TextStyle(
                                  color: Colors.white
                              )
                          ),
                        ),
                        Divider(color: Colors.white,),
                        TextFormField(
                          onChanged: (value) {
                            if(value.isNotEmpty) {
                              setState(() {
                                _passwordFieldError = false;
                              });
                            }
                          },
                          controller: passwordTextEditingController,
                          obscureText: true,
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  color: Colors.white
                              )
                          ),
                          decoration: InputDecoration(
                              errorText: _passwordFieldError ? 'This field is required' : null,
                              icon: Icon(FontAwesomeIcons.lock, color: Colors.white,),
                              border: InputBorder.none,
                              labelText: 'PASSWORD',
                              labelStyle: TextStyle(
                                  color: Colors.white
                              )
                          ),
                        ),
                        Divider(color: Colors.white,),
                        TextFormField(
                          onChanged: (value) {
                            if(value.isNotEmpty) {
                              setState(() {
                                _conformPasswordFieldError = false;
                              });
                            }
                          },
                          controller: conformPasswordTextEditingController,
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  color: Colors.white
                              )
                          ),
                          decoration: InputDecoration(
                              errorText: _conformPasswordFieldError ? 'This field is required' : null,
                              icon: Icon(FontAwesomeIcons.lock, color: Colors.white,),
                              border: InputBorder.none,
                              labelText: 'CONFORM PASSWORD',
                              labelStyle: TextStyle(
                                  color: Colors.white
                              )
                          ),
                        ),
                        Divider(color: Colors.white,),
                        SizedBox(height: 20,),
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
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
                            _singUp();
                          },
                        ),
                        SizedBox(height: 10,),
                        InkWell(
                          splashColor: Color(0xFF013a63),
                          highlightColor: Color(0xFF013a63),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                                "Already have an account?",
                                style: GoogleFonts.telex(
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue
                                  ),
                                )
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
                          },
                        ),
                        SizedBox(height: 20,)
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
