import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_switch_button/custom_switch_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/helper/constants.dart';

class GlobalPostEdit extends StatefulWidget {

  String postID;
  GlobalPostEdit(this.postID);

  @override
  _GlobalPostEditState createState() => _GlobalPostEditState();
}

class _GlobalPostEditState extends State<GlobalPostEdit> {

  TextEditingController textEditingController = new TextEditingController();
  TextEditingController titletextEditingController = new TextEditingController();
  bool isLoading = false;
  bool status = false;
  var color = Colors.white;
  String selectedColor = "lightBlue";
  String fetchedColor = "lightBlue";

  @override
  void initState() {
    getPost();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.clear();
    titletextEditingController.clear();
    print('DISPOSE CALLED');
  }

  String imageURL;
  var photoHashCode;

  Future getPost() async {
    photoHashCode = 0;
    DocumentSnapshot post = await FirebaseFirestore.instance.collection("users").doc(Constants.USER_ID).collection("notes").doc(widget.postID).get();
    textEditingController.text = post.data()['description'];
    titletextEditingController.text = post.data()['title'];
    status = post.data()['status'];
    fetchedColor = post.data()['color'];
    setState(() {
      imageURL = post.data()['photoUrl'];
      photoHashCode = post.data()['photoHashCode'];
      if(fetchedColor == "lightBlue") {
        color = Colors.lightBlue;
      } else if(fetchedColor == "red") {
        color = Colors.red;
      } else if(fetchedColor == "orange") {
        color = Colors.orange;
      } else if(fetchedColor == "purple") {
        color = Colors.purple;
      } else if(fetchedColor == "lightGreen") {
        color = Colors.lightGreen;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading ? Center(child: CircularProgressIndicator(),) : Column(
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
                            "Edit Note",
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
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 45,
                        width: 45,
                        child: Icon(FontAwesomeIcons.solidPaperPlane, size: 18, color: Color(0xFF6c757d)),
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
                      onTap: () {
                        if(textEditingController.text.length != 0 && titletextEditingController.text.length != 0) {

                          setState(() {
                            isLoading = true;
                          });

                          var now = new DateTime.now();
                          var formatter = new DateFormat('yyyy-MM-dd');
                          String formattedDate = formatter.format(now);

                          if(color == Colors.lightBlue) {
                            selectedColor = "lightBlue";
                          } else if(color == Colors.red) {
                            selectedColor = "red";
                          } else if(color == Colors.orange) {
                            selectedColor = "orange";
                          } else if(color == Colors.purple) {
                            selectedColor = "purple";
                          } else if(color == Colors.lightGreen) {
                            selectedColor = "lightGreen";
                          }

                          FirebaseFirestore.instance.collection("users").doc(Constants.USER_ID).collection("notes").doc(widget.postID).update({
                            "description" : textEditingController.text,
                            "title" : titletextEditingController.text,
                            "lastEditedTime" : DateFormat.jm().format(DateTime.now()),
                            "lastEditedDate" : formattedDate,
                            "status" : status,
                            "editedTime" : "${DateTime.now().microsecondsSinceEpoch}",
                            "color" : selectedColor
                          }).whenComplete(() {
                            setState(() {
                              Navigator.pop(context);
                              isLoading = false;
                              Fluttertoast.showToast(
                                msg: "Changes Saved",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Color(0xFFd3e0ea),
                                textColor: Colors.blueAccent,
                                fontSize: 16.0,
                              );
                            });
                          });
                        } else {
                          Fluttertoast.showToast(
                            msg: "Fill all details",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Color(0xFFd3e0ea),
                            textColor: Colors.blueAccent,
                            fontSize: 16.0,
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                  return true;
                },
                child: ListView(
                  children: [
                    Column(
                      children: [
                        photoHashCode != 0 ? SizedBox(height: 30,) : Container(),
                        photoHashCode != 0 ? Container(
                          //height: MediaQuery.of(context).size.height - 400,
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FadeInImage.assetNetwork(
                                    placeholder: 'assets/gif/loading.gif',
                                    image: imageURL,
                                  ),
                                ],
                              ),

                              InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return CupertinoAlertDialog(
                                          title: const Text("Delete image"),
                                          content: Text("Are you sure ?"),
                                          actions: <Widget>[
                                            CupertinoDialogAction(
                                              onPressed: () {
                                                if(photoHashCode != 0) {
                                                  FirebaseFirestore.instance.collection("users").doc(Constants.USER_ID).collection("notes").doc(widget.postID).update(
                                                      {
                                                        "photoHashCode" : 0,
                                                        "photoUrl" : ""
                                                      }
                                                  );
                                                  FirebaseStorage.instance.ref()
                                                      .child('images/$photoHashCode')
                                                      .delete();
                                                }
                                                setState(() {
                                                  photoHashCode = 0;
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Yes'),
                                            ),
                                          ],
                                        );
                                      }
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  height: 45,
                                  width: 45,
                                  child: Icon(Icons.delete, size: 25, color: Colors.white,),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(16)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ) : Container(),

                        SizedBox(height: 40,),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                  "Title:",
                                  style: GoogleFonts.varela(
                                    textStyle: TextStyle(
                                        fontSize: 15
                                    ),
                                  )
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.lightBlueAccent)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                maxLength: 20,
                                maxLengthEnforced: true,
                                controller: titletextEditingController,
                                style: GoogleFonts.varela(
                                  textStyle: TextStyle(
                                      fontSize: 15
                                  ),
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Title",
                                    hintStyle: GoogleFonts.varela(textStyle: TextStyle(color: Colors.grey))
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 40,),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                  "Description:",
                                  style: GoogleFonts.varela(
                                    textStyle: TextStyle(
                                        fontSize: 15
                                    ),
                                  )
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.lightBlueAccent)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                maxLength: 250,
                                maxLengthEnforced: true,
                                controller: textEditingController,
                                style: GoogleFonts.varela(
                                  textStyle: TextStyle(
                                      fontSize: 15
                                  ),
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Description",
                                    hintStyle: GoogleFonts.varela(textStyle: TextStyle(color: Colors.grey))
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Text(
                                "Mark as done : ",
                                style: GoogleFonts.ubuntu(
                                    fontSize: 15
                                ),
                              ),
                              InkWell(
                                highlightColor: Colors.white,
                                splashColor: Colors.white,
                                onTap: () {
                                  setState(() {
                                    status = !status;
                                  });
                                },
                                child: CustomSwitchButton(
                                  backgroundColor: Colors.grey[300],
                                  checked: status,
                                  checkedColor: Colors.lightBlueAccent,
                                  unCheckedColor: Colors.white,
                                  animationDuration: Duration(milliseconds: 400),
                                  buttonHeight: 25,
                                  buttonWidth: 50,
                                  indicatorWidth: 20,
                                ),
                              )
                            ],
                          ),
                        ),

                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Text(
                                  "Color:",
                                  style: GoogleFonts.varela(
                                    textStyle: TextStyle(
                                        fontSize: 15
                                    ),
                                  )
                              ),
                              SizedBox(width: 5,),
                              InkWell(
                                borderRadius: BorderRadius.circular(100),
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
                                                        setState(() {
                                                          color = Colors.lightBlue;
                                                          Navigator.pop(context);
                                                        });
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
                                                        setState(() {
                                                          color = Colors.red;
                                                          Navigator.pop(context);
                                                        });
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
                                                        setState(() {
                                                          color = Colors.orange;
                                                          Navigator.pop(context);
                                                        });
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
                                                        setState(() {
                                                          color = Colors.purple;
                                                          Navigator.pop(context);
                                                        });
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
                                                        setState(() {
                                                          color = Colors.lightGreen;
                                                          Navigator.pop(context);
                                                        });
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
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20,)
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
