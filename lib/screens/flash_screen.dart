import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/authentication/sign_in_ui.dart';
import 'package:notes_app/helper/constants.dart';
import 'package:notes_app/helper/helperfunctions.dart';
import 'package:notes_app/screen_transition/page_transition_effect.dart';
import 'package:notes_app/screens/home_page.dart';
import 'package:notes_app/screens/no_internet_connection.dart';

class SplashScreen extends StatefulWidget {
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  {

  final splashDelay = 2;
  bool userIsLoggedIn;
  bool isInternetConnection;
  String email;

  @override
  void initState() {
    getLoggedInState();
    getUserEmailId();
    super.initState();
    _loadWidget();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn  = value;
      });
    });
  }

  getUserEmailId() async {
    HelperFunctions.getUserEmailSharedPreference().then((value) => {
      setState(() {
        email = value;
        Constants.current_user_emailID = email;
      })
    }
    );
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async {

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('NETWORK STATUS : CONNECTED');
        isInternetConnection = true;
      }
    } on SocketException catch (_) {
      print('NETWORK STATUS : NOT CONNECTED');
      isInternetConnection = false;
    }

    if(isInternetConnection) {
      if(userIsLoggedIn != null) {
        if(userIsLoggedIn) {
          print('LOGGED IN : TRUE');
          Navigator.pushReplacement(context, FadeRoute(page: HomePage()));
        } else {
          print('LOGGED IN : FALSE');
          Navigator.pushReplacement(context, FadeRoute(page: SignIn()));
        }
      } else {
        print('LOGGED IN : FALSE');
        Navigator.pushReplacement(context, FadeRoute(page: SignIn()));
      }
    } else {
      print('NO INTERNET CONNECTION');
      Navigator.pushReplacement(context, FadeRoute(page: NoInternetConnection()));
    }
  }

  @override
  Widget build(BuildContext context) {

    final Shader linearGradient = LinearGradient(
      colors: <Color>[Color(0xFF25CCF7), /*Colors.blue[900]*/ Color(0xFF2422C6)],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 350.0, 70.0));

    return Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/post-it.png',
                            ),
                            fit: BoxFit.fill,
                          ),
                      ),
                      //child: Text("ChatWare"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Text(
                  "My Note",
                  style: GoogleFonts.manjari(
                      textStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          foreground: Paint()..shader = linearGradient
                      )
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}
