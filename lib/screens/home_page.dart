import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/helper/constants.dart';
import 'package:notes_app/helper/helperfunctions.dart';
import 'package:notes_app/screen_transition/page_transition_effect.dart';
import 'package:notes_app/screens/my_notes.dart';
import 'package:notes_app/services/auth.dart';
import 'package:notes_app/services/database.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {

  String dayWish = "Welcome";
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot snapshotUserInfo;

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xFF25CCF7), Color(0xFF2422C6)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 320.0, 70.0));

  AuthMethods authMethods = new AuthMethods();

  @override
  void initState() {
    getLoggedInUserDetails();
    super.initState();
  }

  getLoggedInUserDetails() async {

    databaseMethods.getUserByUserEmail(Constants.current_user_emailID).then((val) {
      snapshotUserInfo = val;

      print("HOME PAGE [ NAME ] : " + snapshotUserInfo.docs[0].data()["name"]);

      print("HOME PAGE [ FIRST NAME ] : " + snapshotUserInfo.docs[0].data()["first_name"]);
      setState(() {
        Constants.FIRST_NAME = snapshotUserInfo.docs[0].data()["first_name"];
      });

      print("HOME PAGE [ LAST NAME ] : " + snapshotUserInfo.docs[0].data()["last_name"]);
      setState(() {
        Constants.LAST_NAME = snapshotUserInfo.docs[0].data()["last_name"];
      });

      print("HOME PAGE [ USER ID ] : " + snapshotUserInfo.docs[0].data()["userID"]);
      setState(() {
        Constants.USER_ID = snapshotUserInfo.docs[0].data()["userID"];
      });
    });
  }

  Future<void> _logout() async {
    await showDialog(
        context: context,
        builder: (BuildContext context){
          return CupertinoAlertDialog(
            title: const Text("Logout"),
            content: Text("Are you sure ?"),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  authMethods.signOut();
                  HelperFunctions.saveUserLoggedInSharedPreference(false);
                  Navigator.of(context).pushNamedAndRemoveUntil('/AuthScreen', (Route<dynamic> route) => false);
                },
                child: const Text('Yes'),
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    DateTime now = new DateTime.now();

    if(now.hour >= 5 && now.hour < 12) {
      dayWish = "Good Morning";
    } else if(now.hour >= 12 && now.hour < 17) {
      dayWish = "Good Afternoon";
    } else if(now.hour >= 17 && now.hour < 21) {
      dayWish = "Good Evening";
    } else if(now.hour >= 21 && now.hour <= 24) {
      dayWish = "Good Night";
    } else {
      dayWish = "Greatness takes time..";
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(16),
                          child: Tooltip(
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[300],
                                      blurRadius: 20,
                                      spreadRadius: 1
                                  ),
                                ]
                            ),
                            textStyle: GoogleFonts.varela(
                                textStyle: TextStyle(
                                    color: Colors.blueAccent
                                )
                            ),
                            message: 'Logout',
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(8),
                              height: 45,
                              width: 45,
                              //child: Icon(Icons.menu_rounded, size: 30,),
                              //child: FaIcon(FontAwesomeIcons.signOutAlt, size: 18, color: Color(0xFF6c757d)),
                              child: Icon(Icons.logout, size: 22, color: Color(0xFF6c757d)),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xFFe8eae6),
                                        blurRadius: 20,
                                        spreadRadius: 3
                                    ),
                                  ]
                              ),
                            ),
                          ),

                          onTap: () {
                            _logout();
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7, //previous 0.8
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    dayWish,
                                    //minFontSize: 26,
                                    //maxFontSize: 26,
                                    style:  GoogleFonts.nunito(
                                        textStyle: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w300,
                                          foreground: Paint()..shader = linearGradient,
                                        )
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    Constants.FIRST_NAME,
                                    //minFontSize: 35,
                                    //maxFontSize: 35,
                                    //overflow: TextOverflow.fade,
                                    style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                          fontSize: 35,
                                            fontWeight: FontWeight.w800,
                                            foreground: Paint()..shader = linearGradient
                                        )
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              ),
            SizedBox(height: 10,),
            Expanded(
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                  return true;
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset('assets/images/undraw_Taking_notes_re_bnaf.png'),
                      SizedBox(height: 50),

                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            //height: 125,
                            width: MediaQuery.of(context).size.width * 0.6,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Color(0xFF25CCF7), Color(0xFF0652DD)]
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFe8eae6),
                                    //color: Colors.grey[500],
                                    offset: Offset(0,8),
                                    blurRadius: 15.0,
                                    spreadRadius: 2
                                  ),
                                ]
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8, right: 8),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                            "My Notes",
                                            style: GoogleFonts.molengo(
                                              textStyle: TextStyle(
                                                fontSize: 30,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      width: 50,
                                      height: 50,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: FaIcon(FontAwesomeIcons.arrowRight, color: Color(0xFF0652DD),)
                                  ),
                                ],
                              )
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, FadeRoute(page: MyNotes()));
                          },
                        ),
                      ),
                      SizedBox(height: 40,)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
