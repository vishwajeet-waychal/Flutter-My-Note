import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_app/main.dart';
import 'package:notes_app/screen_transition/page_transition_effect.dart';

class NoInternetConnection extends StatefulWidget {
  @override
  _NoInternetConnectionState createState() => _NoInternetConnectionState();
}

class _NoInternetConnectionState extends State<NoInternetConnection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/lottie/satellite-dish.json'),
                Text(
                  "No Internet Connection",
                  style: GoogleFonts.ubuntu(
                    fontSize: 18,
                    color: Colors.grey[600]
                  ),
                ),
                SizedBox(height: 20,),
                OutlineButton(
                  splashColor: Colors.grey[300],
                  highlightedBorderColor: Colors.grey,
                  highlightElevation: 0,
                  onPressed: () {
                    Navigator.pushReplacement(context, FadeRoute(page: MyApp()));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wifi, size: 20,),
                      SizedBox(width: 10,),
                      Text(
                        "Retry",
                        style: GoogleFonts.varelaRound(),
                      ),
                    ],
                  ),
                ),
              ],
            )
        )
      ),
    );
  }
}
