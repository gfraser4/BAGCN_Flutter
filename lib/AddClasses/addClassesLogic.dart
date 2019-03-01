import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:bagcndemo/Models/ClassesModel.dart';

class ClassMGMTLogic {
  static addClass(BuildContext context, Classes classes, List<String> userID) {
    try {
      classes.reference.updateData({
        "enrolledUsers": FieldValue.arrayUnion(userID),
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  static removeClass(
      BuildContext context, Classes classes, List<String> userID) {
    try {
      classes.reference.updateData({
        "enrolledUsers": FieldValue.arrayRemove(userID),
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }
}
