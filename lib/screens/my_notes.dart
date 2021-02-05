import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/helper/constants.dart';
import 'package:notes_app/screen_transition/page_transition_effect.dart';
import 'package:notes_app/screens/create_post.dart';
import 'package:notes_app/screens/edit_post.dart';
import 'package:notes_app/screens/image_view.dart';
import 'package:notes_app/screens/loading_shimmer.dart';
import 'package:notes_app/screens/note_search.dart';
import 'package:notes_app/screens/sort_notes.dart';
import 'package:notes_app/services/database.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class MyNotes extends StatefulWidget {
  @override
  _MyNotesState createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xFF25CCF7), Color(0xFF2422C6)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 320.0, 70.0));

  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot snapshotUserInfo;


  final Shader linearGradient1 = LinearGradient(
    colors: <Color>[Color(0xFF25CCF7), Color(0xFF2422C6)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 320.0, 70.0));

  Stream noteStream;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    databaseMethods.getNotes(Constants.USER_ID).then((value) {
      print("******* NOTES CACHED *******");
      setState(() {
        noteStream = value;
      });
    });
    super.initState();
  }

  void _onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      databaseMethods.getNotes(Constants.USER_ID).then((value) {
        print("******* NOTES REFRESHED *******");
        setState(() {
          noteStream = value;
        });
      });
    });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {});
    _refreshController.loadComplete();
  }

  Widget notesTileWidget() {
    return StreamBuilder(
      stream: noteStream,
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return /*Center(
            child: Container(
              child: Shimmer.fromColors(
                child: Text(
                    "No Notes",
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
          );*/
          LoadingShimmer();
        } else if(snapshot.data.documents.length == 0) {
          return /*Center(
            child: Container(
              child: Shimmer.fromColors(
                child: Text(
                    "No Notes",
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
          );*/
            LoadingShimmer();
        } else {
          return snapshot.hasData ? SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: WaterDropMaterialHeader(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            footer: ClassicFooter(
              loadStyle: LoadStyle.ShowWhenLoading,
              completeDuration: Duration(milliseconds: 500),
            ),
            child: ListView.builder(
              //controller: _scrollController,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return NoteTile(snapshot.data.docs[index].data()["username"], snapshot.data.docs[index].data()["description"], snapshot.data.docs[index].data()["title"], snapshot.data.docs[index].data()["photoUrl"], snapshot.data.docs[index].data()["postTime"], snapshot.data.docs[index].data()["lastEditedTime"], snapshot.data.docs[index].data()["postID"], snapshot.data.docs[index].data()["photoHashCode"], snapshot.data.docs[index].data()["postDate"], snapshot.data.docs[index].data()["lastEditedDate"], snapshot.data.docs[index].data()["status"], snapshot.data.docs[index].data()["color"]);
              },
            ),
          ) : Container(
            child: Shimmer.fromColors(
              child: Text("Loading", style: TextStyle(fontSize: 20),),
              baseColor: Colors.grey[700],
              highlightColor: Colors.grey[100],
            ),
          );
        }
      },
    );
  }

  /*Widget loadingShimmer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: ListView.builder(
                itemBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                        ),
                        Container(
                          width: 300,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          width: 200,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          width: 200,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 5,
                          color: Colors.white,
                        )
                      ],
                    )
                ),
                itemCount: 10,
              ),
            ),
          )
        ],
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child : Text(
                            "Your Notes",
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
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          child: Tooltip(
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xFFe8eae6),
                                      blurRadius: 20,
                                      spreadRadius: 3
                                  ),
                                ]
                            ),
                            textStyle: GoogleFonts.varela(
                                textStyle: TextStyle(
                                    color: Colors.blueAccent
                                )
                            ),
                            message: 'Search',
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(8),
                              height: 45,
                              width: 45,
                              //child: Icon(Icons.menu_rounded, size: 30,),
                              //child: FaIcon(FontAwesomeIcons.search, size: 18, color: Color(0xFF6c757d),),
                              child: Icon(Icons.search, size: 25, color: Color(0xFF6c757d),),
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
                            Navigator.push(context, FadeRoute(page: NoteSearch()));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          child: Tooltip(
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xFFe8eae6),
                                      blurRadius: 20,
                                      spreadRadius: 3
                                  ),
                                ]
                            ),
                            textStyle: GoogleFonts.varela(
                                textStyle: TextStyle(
                                    color: Colors.blueAccent
                                )
                            ),
                            message: 'Sort',
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(8),
                              height: 45,
                              width: 45,
                              //child: Icon(Icons.menu_rounded, size: 30,),
                              //child: FaIcon(FontAwesomeIcons.filter, size: 18, color: Color(0xFF6c757d)),
                              child: Icon(Icons.filter_alt_rounded, size: 25, color: Color(0xFF6c757d),),
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
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    //elevation: 16,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Text(
                                            "Sort",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.josefinSans(
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                shadows: <Shadow>[
                                                  Shadow(
                                                      offset: Offset(2, 2),
                                                      blurRadius: 4,
                                                      color: Colors.grey[300]
                                                  )
                                                ]
                                            ),
                                          ),
                                        ),
                                        Divider(),
                                        InkWell(
                                          highlightColor: Colors.white,
                                            splashColor: Colors.white,
                                            //borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 60,
                                              child: Text(
                                                "By last created",
                                                style: GoogleFonts.varela(
                                                    textStyle: TextStyle(
                                                        fontSize: 20
                                                    )
                                                ),
                                              ),
                                            ),

                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(context, FadeRoute(page: SortNote("created")));
                                            }
                                        ),

                                        InkWell(
                                            highlightColor: Colors.white,
                                            splashColor: Colors.white,
                                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 60,
                                              child: Text(
                                                "By last modified",
                                                style: GoogleFonts.varela(
                                                    textStyle: TextStyle(
                                                        fontSize: 20
                                                    )
                                                ),
                                              ),
                                            ),

                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(context, FadeRoute(page: SortNote("edited")));
                                            }
                                        ),

                                        InkWell(
                                            highlightColor: Colors.white,
                                            splashColor: Colors.white,
                                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 60,
                                              child: Text(
                                                "By color",
                                                style: GoogleFonts.varela(
                                                    textStyle: TextStyle(
                                                        fontSize: 20
                                                    )
                                                ),
                                              ),
                                            ),

                                            onTap: () {
                                              Navigator.pop(context);
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog(
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                      //elevation: 16,
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 10),
                                                            child: Text(
                                                              "Color",
                                                              overflow: TextOverflow.ellipsis,
                                                              style: GoogleFonts.josefinSans(
                                                                  color: Colors.blueAccent,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 25,
                                                                  shadows: <Shadow>[
                                                                    Shadow(
                                                                        offset: Offset(2, 2),
                                                                        blurRadius: 4,
                                                                        color: Colors.grey[300]
                                                                    )
                                                                  ]
                                                              ),
                                                            ),
                                                          ),
                                                          Divider(),
                                                          Padding(
                                                            padding: const EdgeInsets.only(bottom: 10),
                                                            child: Wrap(
                                                              spacing: 10,
                                                              runSpacing: 10,
                                                              children: [
                                                                InkWell(
                                                                  borderRadius: BorderRadius.circular(100),
                                                                  onTap: () {
                                                                    Navigator.pop(context);
                                                                    Navigator.push(context, FadeRoute(page: SortNote("lightBlue")));
                                                                  },
                                                                  child: Container(
                                                                    height: 45,
                                                                    width: 45,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(100),
                                                                        color: Colors.lightBlue
                                                                    ),
                                                                  ),
                                                                ),

                                                                InkWell(
                                                                  borderRadius: BorderRadius.circular(100),
                                                                  onTap: () {
                                                                    Navigator.pop(context);
                                                                    Navigator.push(context, FadeRoute(page: SortNote("red")));
                                                                  },
                                                                  child: Container(
                                                                    height: 45,
                                                                    width: 45,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(100),
                                                                        color: Colors.red
                                                                    ),
                                                                  ),
                                                                ),

                                                                InkWell(
                                                                  borderRadius: BorderRadius.circular(100),
                                                                  onTap: () {
                                                                    Navigator.pop(context);
                                                                    Navigator.push(context, FadeRoute(page: SortNote("orange")));
                                                                  },
                                                                  child: Container(
                                                                    height: 45,
                                                                    width: 45,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(100),
                                                                        color: Colors.orange
                                                                    ),
                                                                  ),
                                                                ),

                                                                InkWell(
                                                                  borderRadius: BorderRadius.circular(100),
                                                                  onTap: () {
                                                                    Navigator.pop(context);
                                                                    Navigator.push(context, FadeRoute(page: SortNote("purple")));
                                                                  },
                                                                  child: Container(
                                                                    height: 45,
                                                                    width: 45,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(100),
                                                                        color: Colors.purple
                                                                    ),
                                                                  ),
                                                                ),

                                                                InkWell(
                                                                  borderRadius: BorderRadius.circular(100),
                                                                  onTap: () {
                                                                    Navigator.pop(context);
                                                                    Navigator.push(context, FadeRoute(page: SortNote("lightGreen")));
                                                                  },
                                                                  child: Container(
                                                                    height: 45,
                                                                    width: 45,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(100),
                                                                        color: Colors.lightGreen
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }
                                              );
                                            }
                                        ),
                                      ],
                                    ),
                                  );
                                }
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
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
                            message: 'Create',
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(8),
                              height: 45,
                              width: 45,
                              //child: Icon(Icons.menu_rounded, size: 30,),
                              //child: FaIcon(FontAwesomeIcons.plus, size: 18, color: Color(0xFF6c757d)),
                              child: Icon(Icons.add_rounded, size: 26, color: Color(0xFF6c757d),),
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

                          onTap: () {
                            Navigator.push(context, FadeRoute(page: CreatePost()));
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: notesTileWidget(),
            ),
          ],
        )
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