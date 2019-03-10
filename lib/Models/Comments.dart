import 'package:cloud_firestore/cloud_firestore.dart';

//CLASS MAP BASED ON FIRESTORE ANNOUNCEMENT TABLE
class Comments {
  final String userID;
  final String commentID;
  final String announcementID;
  final String firstName;
  final String lastName;
  final String content;
  final DateTime created;
  final String profileColor;
  final bool visible;
  final DocumentReference reference;

  Comments.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['firstName'] != null),
        assert(map['lastName'] != null),
        assert(map['userID'] != null),
        assert(map['commentID'] != null),
        assert(map['announcementID'] != null),
        assert(map['content'] != null),
        assert(map['created'] != null),
        assert(map['profileColor'] != null),
        assert(map['visible'] != null),
        firstName = map['firstName'],
        userID = map['userID'],
        lastName = map['lastName'],
        profileColor = map['profileColor'],
        commentID = map['commentID'],
        announcementID = map['announcementID'],
        content = map['content'],
        visible = map['visible'],
        created = map['created'];
        

  Comments.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  // @override
  // String toString() => "Record<$clsName:$title>";
}
