import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/services/auth.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  bool _emailFieldError = false;
  TextEditingController emailTextEditingController = TextEditingController();
  AuthMethods authMethods = new AuthMethods();

  _forgotPassword() async {
    if(emailTextEditingController.text == null || emailTextEditingController.text.length == 0) {
      setState(() {
        _emailFieldError = true;
      });
    } else {
      await authMethods.resetPass(emailTextEditingController.text). then((value){
        setState(() {
          //isLoading = false;
        });
        emailTextEditingController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF013a63),
      body: SafeArea(
        child: Center(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
              return true;
            },
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                            "Forgot Password",
                            style: GoogleFonts.michroma(
                              textStyle: TextStyle(
                                  fontSize: 35,
                                  color: Colors.white
                              ),
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          SizedBox(height: 20,),
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "Forgot Password",
                                    style: GoogleFonts.telex(
                                      textStyle: TextStyle(
                                          color: Color(0xFF013a63),
                                          fontSize: 18
                                      ),
                                    )
                                ),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white
                              ),
                            ),
                            onTap: () {
                              _forgotPassword();
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
