import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:bagcndemo/Models/ClassesModel.dart';

class ClassMGMTLogic {
  static addClass(BuildContext context, Classes classes, List<String> userID) async {
    try {
      await classes.reference.updateData({
        "enrolledUsers": FieldValue.arrayUnion(userID),
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  
  static removeClass(
      BuildContext context, Classes classes, List<String> userID) async {
    try {
     await classes.reference.updateData({
        "enrolledUsers": FieldValue.arrayRemove(userID),
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  static openClass(BuildContext context, Classes classes, List<String> userID, String passCode) async {
    try {
      await classes.reference.updateData({
        "supervisors": FieldValue.arrayUnion(userID),
        "passcode" : passCode,
        "isActive": true
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  static closeClass(
      BuildContext context, Classes classes, List<String> userID) async {
    try {
      await classes.reference.updateData({
        "enrolledUsers": [],
        "supervisors": [],
        "passcode": "",
        "isActive": false
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

}
