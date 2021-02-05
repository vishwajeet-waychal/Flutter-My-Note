import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_app/helper/constants.dart';
import 'package:notes_app/services/database.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  TextEditingController textEditingController = new TextEditingController();
  TextEditingController titleTextEditingController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final _storage = FirebaseStorage.instance;
  var file;
  PickedFile image;
  bool isLoading = false;
  int imageHashCode;
  bool isListEmpty = false;
  var color = Colors.lightBlue;
  String selectedColor = "lightBlue";

  getImage() async {
    final _picker = ImagePicker();
    image = await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    file = File(image.path);
    setState(() {});
  }

  upload() async {

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

    if(textEditingController.text != null && textEditingController.text.length != 0 && titleTextEditingController.text != null && titleTextEditingController.text.length != 0) {
      if(image != null) {
        setState(() {
          isLoading = true;
        });
        imageHashCode = image.hashCode;
        var snapshot = await _storage.ref().child('images/$imageHashCode').putFile(file).whenComplete(() {
          setState(() {
            isLoading = false;
          });
        });
        var downUrl = await snapshot.ref.getDownloadURL();
        var now = new DateTime.now();
        var formatter = new DateFormat('yyyy-MM-dd');
        String formattedDate = formatter.format(now);

        Map<String, dynamic> noteDetail = {
          "username" : Constants.FIRST_NAME + " " + Constants.LAST_NAME,
          "photoUrl" : downUrl,
          "photoHashCode" : imageHashCode,
          "title" : titleTextEditingController.text,
          "description" : textEditingController.text,
          "time" : "${DateTime.now().microsecondsSinceEpoch}",
          "postTime" : DateFormat.jm().format(DateTime.now()),
          "postDate" : formattedDate,
          "lastEditedTime" : DateFormat.jm().format(DateTime.now()),
          "lastEditedDate" : formattedDate,
          "postID" : "",
          "status" : false,
          "color" : selectedColor
        };

        await databaseMethods.addNote(noteDetail);
        //await FirebaseFirestore.instance.collection("users").doc(Constants.USER_ID).collection("notes").add(noteDetail);

        Navigator.pop(context);
        //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
        Fluttertoast.showToast(
          msg: "Note added",
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
        var now = new DateTime.now();
        var formatter = new DateFormat('yyyy-MM-dd');
        String formattedDate = formatter.format(now);

        Map<String, dynamic> noteDetail = {
          "username" : Constants.FIRST_NAME + " " + Constants.LAST_NAME,
          "photoUrl" : "",
          "photoHashCode" : 0,
          "title" : titleTextEditingController.text,
          "description" : textEditingController.text,
          "time" : "${DateTime.now().microsecondsSinceEpoch}",
          "editedTime" : "${DateTime.now().microsecondsSinceEpoch}",
          "postTime" : DateFormat.jm().format(DateTime.now()),
          "postDate" : formattedDate,
          "lastEditedTime" : DateFormat.jm().format(DateTime.now()),
          "lastEditedDate" : formattedDate,
          "postID" : "",
          "status" : false,
          "color" : selectedColor
        };

        await databaseMethods.addNote(noteDetail);
        //await FirebaseFirestore.instance.collection("users").doc(Constants.USER_ID).collection("notes").add(noteDetail);

        Navigator.pop(context);
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyNotes()));

        Fluttertoast.showToast(
          msg: "Note added",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xFFd3e0ea),
          textColor: Colors.blueAccent,
          fontSize: 16.0,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Please Fill Details",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(0xFFd3e0ea),
        textColor: Colors.blueAccent,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading ? Container(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      child: Lottie.asset('assets/lottie/zig-zag-arrow-ball-loader.json')
                  ),
                ),
              ],
            ),
          ),
        ) : Column(
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
                            "Create note",
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
                                  color: Color(0xFFe8eae6),
                                  blurRadius: 20,
                                  spreadRadius: 3
                              ),
                            ]
                        ),
                      ),
                      onTap: () {
                        upload();
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
                        SizedBox(height: 90,),
                        InkWell(
                          borderRadius: BorderRadius.circular(100),
                          child:  image != null ? Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Card(
                                elevation: 10,
                                child: Image.file(
                                  File(image.path),
                                  height: 150,
                                  width: 150,
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.blue
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.trash,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      image = null;
                                    });
                                  },
                                  iconSize: 18,
                                ),
                              ),
                            ],
                          ) : Container(
                            height: 70,
                            width: 70,
                            child: Icon(Icons.image_rounded, color: Colors.white,),
                            decoration: BoxDecoration(
                                color: Color(0xFF6c757d),
                                borderRadius: BorderRadius.circular(100)
                            ),
                          ),
                          onTap: () {
                            getImage();
                          },
                        ),
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
                                controller: titleTextEditingController,
                                style: GoogleFonts.varela(
                                  textStyle: TextStyle(
                                      fontSize: 15
                                  ),
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Enter Title",
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
                                    hintText: "Enter Description",
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
                            mainAxisAlignment: MainAxisAlignment.end,
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
