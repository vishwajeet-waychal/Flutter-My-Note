import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_app/helper/constants.dart';
import 'package:notes_app/screen_transition/page_transition_effect.dart';
import 'package:notes_app/screens/edit_post.dart';
import 'package:notes_app/screens/image_view.dart';
import 'package:notes_app/services/database.dart';
import 'package:shimmer/shimmer.dart';

class NoteSearch extends StatefulWidget {
  @override
  _NoteSearchState createState() => _NoteSearchState();
}

class _NoteSearchState extends State<NoteSearch> {

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xFF25CCF7), Color(0xFF2422C6)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 320.0, 70.0));

  TextEditingController searchTextEditingController = new TextEditingController();
  bool isLoading = false;
  bool isSearchButtonPressed = false;
  Stream snapshot;

  Widget notesTileWidget() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("users").doc(Constants.USER_ID).collection("notes").where("title", isEqualTo: searchTextEditingController.text).snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return Center(
            child: Container(
              child: Shimmer.fromColors(
                child: Text(
                    "",
                    style: GoogleFonts.nunito(
                      textStyle: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w300
                      ),
                    )
                ),
                baseColor: Colors.grey[700],
                highlightColor: Colors.grey[100],
              ),
            ),
          );
        } else if(snapshot.data.documents.length == 0 && isSearchButtonPressed) {
          return Center(
            child: Container(
              child: Shimmer.fromColors(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                        "No Notes Found",
                        style: GoogleFonts.nunito(
                          textStyle: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w300
                          ),
                        )
                    ),
                  ),
                ),
                baseColor: Colors.grey[700],
                highlightColor: Colors.grey[100],
              ),
            ),
          );
        } else {
          return NotificationListener <OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
              return true;
            },
            child: ListView.builder(
              itemCount: snapshot.data.documents.length,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              itemBuilder: (context, index) {
                return NoteTile(snapshot.data.docs[index].data()["username"], snapshot.data.docs[index].data()["description"], snapshot.data.docs[index].data()["title"], snapshot.data.docs[index].data()["photoUrl"], snapshot.data.docs[index].data()["postTime"], snapshot.data.docs[index].data()["lastEditedTime"], snapshot.data.docs[index].data()["postID"], snapshot.data.docs[index].data()["photoHashCode"], snapshot.data.docs[index].data()["postDate"], snapshot.data.docs[index].data()["lastEditedDate"], snapshot.data.docs[index].data()["status"], snapshot.data.docs[index].data()["color"]);
              },
            ),
          );
        }
      },
    );
  }

DatabaseMethods databaseMethods = new DatabaseMethods();

  initiateSearch() async {
    if(searchTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter title",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(0xFFd3e0ea),
        textColor: Colors.blueAccent,
        fontSize: 16.0,
      );
    } else {
      setState(() {
        isLoading = true;
      });
      databaseMethods.getNotesByTitle(searchTextEditingController.text).then((value) {
        print("******* NOTES FETCHED *******");
        setState(() {
          snapshot = value;
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24)
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[400],
                        blurRadius: 64,
                        offset: Offset(16,4)
                    )
                  ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Search note",
                            style: GoogleFonts.josefinSans(
                                textStyle: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    shadows: <Shadow>[
                                      Shadow(
                                          offset: Offset(2, 2),
                                          blurRadius: 4,
                                          color: Colors.grey[300]
                                      )
                                    ]
                                )
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 60,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                "Type title",
                style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        shadows: <Shadow>[
                          Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 4,
                              color: Colors.grey[400]
                          )
                        ]
                    )
                ),
              ),
            ),

            SizedBox(height: 20,),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.only(left: 20, right: 5),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: TextField(
                      style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(
                              color: Colors.white,
                              //fontWeight: FontWeight.bold
                          )
                      ),
                      cursorColor: Colors.white,
                      autofocus: true,
                      controller: searchTextEditingController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          hintText: "Search title",
                          hintStyle: GoogleFonts.ubuntu(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  //fontWeight: FontWeight.bold
                              )
                          )
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: isLoading ? Container(
                      alignment: Alignment.center,
                      child: Lottie.asset('assets/lottie/loading.json')
                  ) : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: InkWell(
                      child: Icon(Icons.search, color: Colors.white,),

                      onTap: () {
                        isSearchButtonPressed = true;
                        initiateSearch();
                      },
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 30,),
            Expanded(child: notesTileWidget())
          ],
        ),
      ),
    );
  }
}

class NoteTile extends StatelessWidget {

  final String username;
  final String description;
  final String title;
  final String imageUrl;
  final String postTime;
  final String lastEditedTime;
  final String postID;
  final int photoHashCode;
  final String postDate;
  final String lastEditedDate;
  final bool status;
  final String color;
  NoteTile(this.username, this.description, this.title, this.imageUrl, this.postTime, this.lastEditedTime, this.postID, this.photoHashCode, this.postDate, this.lastEditedDate, this.status, this.color);

  @override
  Widget build(BuildContext context) {
    var selectedColor = Colors.lightBlue;

    if(color == "lightBlue") {
      selectedColor = Colors.lightBlue;
    } else if(color == "red") {
      selectedColor = Colors.red;
    } else if(color == "orange") {
      selectedColor = Colors.orange;
    } else if(color == "purple") {
      selectedColor = Colors.purple;
    } else if(color == "lightGreen") {
      selectedColor = Colors.lightGreen;
    }

    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 5),
      child: !status ? Material(
        shadowColor: Colors.indigoAccent[100],
        elevation: 15,
        borderRadius: BorderRadius.circular(10),
        child: ClipPath(
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))
              )
          ),
          child: Container(
            /*shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            shadowColor: Colors.indigoAccent[100],
            elevation: 15,*/

            decoration: BoxDecoration(
              color: Colors.white,
              //borderRadius: BorderRadius.circular(10),
              border: Border(
                  left: BorderSide(width: 10.0, color: selectedColor)
              ),
              /*boxShadow: [BoxShadow(
                  color: Colors.indigoAccent[100],
                  offset: Offset(0, 2),
                  blurRadius: 5.0,
                ),]*/
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          //width: MediaQuery.of(context).size.width * 0.3,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              //color: Colors.blueAccent,
                            ),
                            child: Text(
                              "Title : " + title,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.josefinSans(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  shadows: <Shadow>[
                                    Shadow(
                                        offset: Offset(2, 2),
                                        blurRadius: 4,
                                        color: Colors.grey[300]
                                    )
                                  ]
                              ),
                            )
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(context, FadeRoute(page: GlobalPostEdit(postID)));
                            },
                            child: Tooltip(
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xFFe8eae6),
                                        blurRadius: 20,
                                        spreadRadius: 2
                                    ),
                                  ]
                              ),
                              textStyle: GoogleFonts.varela(
                                  textStyle: TextStyle(
                                      color: Colors.blueAccent
                                  )
                              ),
                              message: 'Edit',
                              child: Container(
                                padding: EdgeInsets.all(8),
                                height: 45,
                                width: 45,
                                child: Icon(Icons.edit, size: 18, color: Color(0xFF6c757d)),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xFFe8eae6),
                                          blurRadius: 20,
                                          spreadRadius: 2
                                      ),
                                    ]
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return CupertinoAlertDialog(
                                      title: const Text("Delete note"),
                                      content: Text("Are you sure ?"),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          onPressed: () {
                                            FirebaseFirestore.instance.collection("users").doc(Constants.USER_ID).collection("notes").doc(postID).delete();
                                            if(photoHashCode != 0) {
                                              FirebaseStorage.instance.ref()
                                                  .child('images/$photoHashCode')
                                                  .delete();
                                            }
                                            Navigator.pop(context);
                                            Fluttertoast.showToast(
                                              msg: "Note Deleted",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Color(0xFFd3e0ea),
                                              textColor: Colors.blueAccent,
                                              fontSize: 16.0,
                                            );
                                          },
                                          child: const Text('Yes'),
                                        ),
                                      ],
                                    );
                                  }
                              );
                            },
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
                              message: 'Delete',
                              child: Container(
                                padding: EdgeInsets.all(8),
                                height: 45,
                                width: 45,
                                child: Icon(Icons.delete, size: 18, color: Color(0xFF6c757d)),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[300],
                                          blurRadius: 20,
                                          spreadRadius: 1
                                      ),
                                    ]
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 10,),
                  photoHashCode != 0 ? InkWell(
                    onTap: () {
                      Navigator.push(context, ScaleRoute(page: ImageView(imageUrl)));
                    },
                    child: Container(
                      //height: MediaQuery.of(context).size.height - 400,
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/gif/loading.gif',
                        image: imageUrl,
                      ),
                    ),
                  ) : Container(),
                  photoHashCode != 0 ? SizedBox(height: 10,) : Container(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      children: [
                        Text(
                          "Description : ",
                          style: GoogleFonts.ubuntu(
                              fontSize: 15,
                              color: Colors.purple
                          ),
                        ),
                        /*Text(
                          description,
                          style: GoogleFonts.ubuntu(
                              fontSize: 15
                          ),
                        ),*/
                        ExpandableText(
                          description,
                          expandText: 'show more',
                          collapseText: 'show less',
                          maxLines: 3,
                          textAlign: TextAlign.start,
                          linkColor: Colors.blue,
                          style: GoogleFonts.ubuntu(
                              fontSize: 15
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Divider(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          children: [
                            Text(
                              "Created on: ",
                              style: GoogleFonts.workSans(
                                  fontSize: 13,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            Text(
                              postDate,
                              style: GoogleFonts.workSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300
                              ),
                            ),
                            Text(
                              " " + postTime,
                              style: GoogleFonts.workSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          children: [
                            Text(
                              "Last Modified on: ",
                              style: GoogleFonts.workSans(
                                  fontSize: 13,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            Text(
                              lastEditedDate,
                              style: GoogleFonts.workSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300
                              ),
                            ),
                            Text(
                              " " + lastEditedTime,
                              style: GoogleFonts.workSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ) : Material(
        //shadowColor: Colors.lightBlueAccent[100],
        shadowColor: selectedColor.shade300,
        elevation: 15,
        borderRadius: BorderRadius.circular(10),
        child: ClipPath(
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))
              )
          ),
          child: Container(
            /*shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            shadowColor: Colors.indigoAccent[100],
            elevation: 15,*/

            decoration: BoxDecoration(
              color: selectedColor,
              //color: Color(0xFF11698e),
              //borderRadius: BorderRadius.circular(10),
              border: Border(
                  left: BorderSide(width: 5.0, color: selectedColor)
              ),
              /*boxShadow: [BoxShadow(
                  color: Colors.indigoAccent[100],
                  offset: Offset(0, 2),
                  blurRadius: 5.0,
                ),]*/
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            FaIcon(FontAwesomeIcons.solidCheckCircle, color: Colors.yellow,),
                            Text(
                              " Done",
                              style: GoogleFonts.ubuntu(
                                  fontSize: 15,
                                  color: Colors.yellow
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          //width: MediaQuery.of(context).size.width * 0.3,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              //color: Colors.blueAccent,
                            ),
                            child: Text(
                              "Title : " + title,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.josefinSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              ),
                            )
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(context, FadeRoute(page: GlobalPostEdit(postID)));
                            },
                            child: Tooltip(
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              textStyle: GoogleFonts.varela(
                                  textStyle: TextStyle(
                                      color: Colors.blueAccent
                                  )
                              ),
                              message: 'Edit',
                              child: Container(
                                padding: EdgeInsets.all(8),
                                height: 45,
                                width: 45,
                                child: Icon(Icons.edit, size: 18, color: Colors.white),
                                decoration: BoxDecoration(
                                  //color: Colors.white,
                                    color: selectedColor.shade200,
                                    borderRadius: BorderRadius.circular(16)
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return CupertinoAlertDialog(
                                      title: const Text("Delete note"),
                                      content: Text("Are you sure ?"),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          onPressed: () {
                                            FirebaseFirestore.instance.collection("users").doc(Constants.USER_ID).collection("notes").doc(postID).delete();
                                            if(photoHashCode != 0) {
                                              FirebaseStorage.instance.ref()
                                                  .child('images/$photoHashCode')
                                                  .delete();
                                            }
                                            Navigator.pop(context);
                                            Fluttertoast.showToast(
                                              msg: "Note Deleted",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Color(0xFFd3e0ea),
                                              textColor: Colors.blueAccent,
                                              fontSize: 16.0,
                                            );
                                          },
                                          child: const Text('Yes'),
                                        ),
                                      ],
                                    );
                                  }
                              );
                            },
                            child: Tooltip(
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              textStyle: GoogleFonts.varela(
                                  textStyle: TextStyle(
                                      color: Colors.blueAccent
                                  )
                              ),
                              message: 'Delete',
                              child: Container(
                                padding: EdgeInsets.all(8),
                                height: 45,
                                width: 45,
                                child: Icon(Icons.delete, size: 18, color: Colors.white),
                                decoration: BoxDecoration(
                                  //color: Colors.white,
                                    color: selectedColor.shade200,
                                    borderRadius: BorderRadius.circular(16)
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 10,),
                  photoHashCode != 0 ? InkWell(
                    onTap: () {
                      Navigator.push(context, ScaleRoute(page: ImageView(imageUrl)));
                    },
                    child: Container(
                      //height: MediaQuery.of(context).size.height - 400,
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/gif/loading.gif',
                        image: imageUrl,
                      ),
                    ),
                  ) : Container(),
                  photoHashCode != 0 ? SizedBox(height: 10,) : Container(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      children: [
                        Text(
                          "Description : ",
                          style: GoogleFonts.ubuntu(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        /*Text(
                          description,
                          style: GoogleFonts.ubuntu(
                              fontSize: 15
                          ),
                        ),*/
                        ExpandableText(
                          description,
                          expandText: 'show more',
                          collapseText: 'show less',
                          maxLines: 3,
                          textAlign: TextAlign.start,
                          linkColor: Colors.yellow,
                          style: GoogleFonts.ubuntu(
                              fontSize: 15,
                              color: Colors.white
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Divider(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          children: [
                            Text(
                              "Created on: ",
                              style: GoogleFonts.workSans(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            Text(
                              postDate,
                              style: GoogleFonts.workSans(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300
                              ),
                            ),
                            Text(
                              " " + postTime,
                              style: GoogleFonts.workSans(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          children: [
                            Text(
                              "Last Modified on: ",
                              style: GoogleFonts.workSans(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            Text(
                              lastEditedDate,
                              style: GoogleFonts.workSans(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300
                              ),
                            ),
                            Text(
                              " " + lastEditedTime,
                              style: GoogleFonts.workSans(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}