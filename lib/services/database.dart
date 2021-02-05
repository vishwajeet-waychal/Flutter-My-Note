import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/helper/constants.dart';

class DatabaseMethods {

  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance.collection("users").where("name", isEqualTo: username).get();
  }

  getUserByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: userEmail).get();
  }

  uploadUserInfo(userMap) {
    DocumentReference userRef = FirebaseFirestore.instance.collection("users").doc();
    userRef.set(userMap).whenComplete(() {
      FirebaseFirestore.instance.collection("users").doc(userRef.id).update(
        {
          "userID" : userRef.id
        }
      );
    });
  }

  getNotes(String userID) async {
    return await FirebaseFirestore.instance.collection("users").doc(userID).collection("notes").orderBy("time", descending: true).snapshots();
  }

  getNotesByColor(String userID, String color) async {
    return await FirebaseFirestore.instance.collection("users").doc(userID).collection("notes").orderBy("time", descending: true).where("color", isEqualTo: color).snapshots();   //order by add krayach rahil aahe
  }

  getNotesByCreatedTime(String userID) async {
    return await FirebaseFirestore.instance.collection("users").doc(userID).collection("notes").orderBy("time", descending: true).snapshots();
  }

  getNotesByEditedTime(String userID) async {
    return await FirebaseFirestore.instance.collection("users").doc(userID).collection("notes").orderBy("editedTime", descending: true).snapshots();
  }

  getNotesByTitle(String title) async {
    return await FirebaseFirestore.instance.collection("users").doc(Constants.USER_ID).collection("notes").where("title", isEqualTo: title).orderBy("time", descending: true).snapshots();
  }

  addNote(noteDetail) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection("users").doc(Constants.USER_ID).collection("notes").doc();
    documentReference.set(noteDetail).whenComplete(() {
      print("DOC ID: " + documentReference.id);
      FirebaseFirestore.instance.collection("users").doc(Constants.USER_ID).collection("notes").doc(documentReference.id).update(
          {"postID" : documentReference.id});
    });
  }
}
