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
import 'package:notes_app/screens/edit_post.dart';
import 'package:notes_app/screens/image_view.dart';
import 'package:notes_app/screens/loading_shimmer.dart';
import 'package:notes_app/screens/note_search.dart';
import 'package:notes_app/services/database.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class SortNote extends StatefulWidget {

  String sortType;
  SortNote(this.sortType);

  @override
  _SortNoteState createState() => _SortNoteState();
}

class _SortNoteState extends State<SortNote> {

  Stream noteStream;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotes();
  }

  getNotes() async {
    if(widget.sortType == "created") {
      databaseMethods.getNotesByCreatedTime(Constants.USER_ID).then((value) {
        print("******* SORTED NOTES CACHED *******");
        setState(() {
          noteStream = value;
        });
      });
    } else if(widget.sortType == "edited") {
      databaseMethods.getNotesByEditedTime(Constants.USER_ID).then((value) {
        print("******* SORTED NOTES CACHED *******");
        setState(() {
          noteStream = value;
        });
      });
    } else if(widget.sortType == "lightBlue") {
      setState(() {
        databaseMethods.getNotesByColor(Constants.USER_ID, "lightBlue").then((value) {
          print("******* SORTED NOTES CACHED *******");
          setState(() {
            noteStream = value;
          });
        });
      });
    } else if(widget.sortType == "red") {
      setState(() {
        databaseMethods.getNotesByColor(Constants.USER_ID, "red").then((value) {
          print("******* SORTED NOTES CACHED *******");
          setState(() {
            noteStream = value;
          });
        });
      });
    } else if(widget.sortType == "orange") {
      setState(() {
        databaseMethods.getNotesByColor(Constants.USER_ID, "orange").then((value) {
          print("******* SORTED NOTES CACHED *******");
          setState(() {
            noteStream = value;
          });
        });
      });
    } else if(widget.sortType == "purple") {
      setState(() {
        databaseMethods.getNotesByColor(Constants.USER_ID, "purple").then((value) {
          print("******* SORTED NOTES CACHED *******");
          setState(() {
            noteStream = value;
          });
        });
      });
    } else if(widget.sortType == "lightGreen") {
      setState(() {
        databaseMethods.getNotesByColor(Constants.USER_ID, "lightGreen").then((value) {
          print("******* SORTED NOTES CACHED *******");
          setState(() {
            noteStream = value;
          });
        });
      });
    }
  }

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    if(widget.sortType == "created") {
      setState(() {
        databaseMethods.getNotesByCreatedTime(Constants.USER_ID).then((value) {
          print("******* SORTED NOTES REFRESHED *******");
          setState(() {
            noteStream = value;
          });
        });
      });
    } else if(widget.sortType == "edited") {
      setState(() {
        databaseMethods.getNotesByEditedTime(Constants.USER_ID).then((value) {
          print("******* SORTED NOTES REFRESHED *******");
          setState(() {
            noteStream = value;
          });
        });
      });
    } else if(widget.sortType == "lightBlue") {
      setState(() {
        databaseMethods.getNotesByColor(Constants.USER_ID, "lightBlue").then((value) {
          print("******* SORTED NOTES REFRESHED *******");
          setState(() {
            noteStream = value;
          });
        });
      });
    } else if(widget.sortType == "red") {
      setState(() {
        databaseMethods.getNotesByColor(Constants.USER_ID, "red").then((value) {
          print("******* SORTED NOTES REFRESHED *******");
          setState(() {
            noteStream = value;
          });
        });
      });
    } else if(widget.sortType == "orange") {
      setState(() {
        databaseMethods.getNotesByColor(Constants.USER_ID, "orange").then((value) {
          print("******* SORTED NOTES REFRESHED *******");
          setState(() {
            noteStream = value;
          });
        });
      });
    } else if(widget.sortType == "purple") {
      setState(() {
        databaseMethods.getNotesByColor(Constants.USER_ID, "purple").then((value) {
          print("******* SORTED NOTES REFRESHED *******");
          setState(() {
            noteStream = value;
          });
        });
      });
    } else if(widget.sortType == "lightGreen") {
      setState(() {
        databaseMethods.getNotesByColor(Constants.USER_ID, "lightGreen").then((value) {
          print("******* SORTED NOTES REFRESHED *******");
          setState(() {
            noteStream = value;
          });
        });
      });
    }
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
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

  @override
  Widget build(BuildContext context) {

    String sortType;
    var color;

    if(widget.sortType == "created") {
      sortType = "By last created time";
    } else if(widget.sortType == "edited") {
      sortType = "By last edited time";
    } else if(widget.sortType == "lightBlue") {
      sortType = "By light-blue color";
      color = Colors.lightBlue;
    } else if(widget.sortType == "red") {
      sortType = "By red color";
      color = Colors.red;
    } else if(widget.sortType == "orange") {
      sortType = "By orange color";
      color = Colors.orange;
    } else if(widget.sortType == "purple") {
      sortType = "By purple color";
      color = Colors.purple;
    } else if(widget.sortType == "lightGreen") {
      sortType = "By light-green color";
      color = Colors.lightGreen;
    }

    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
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
                                child : Text("Sorted Notes",
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
                                    //child: FaIcon(FontAwesomeIcons.search, size: 18, color: Color(0xFF6c757d)),
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
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 23, bottom: 8, right: 23),
                    child: Row(
                      children: [
                        color != null ? Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(50)
                          ),
                        ) : Container(),
                        color != null ? SizedBox(width: 5) : Container(),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child : Text(
                                sortType,
                                style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                        fontSize: 17,
                                        color: Color(0xFF6c757d),
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
                      ],
                    ),
                  ),
                ],
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
