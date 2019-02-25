import 'package:cloud_firestore/cloud_firestore.dart';

//CLASS MAP BASED ON FIRESTORE ANNOUNCEMENT TABLE
class Comments {
  final String commentID;
  final String announcementID;
  final String firstName;
  final String lastName;
  final String content;
  final DateTime created;
  final bool visible;
  final DocumentReference reference;

  Comments.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['firstName'] != null),
        assert(map['lastName'] != null),
        assert(map['commentID'] != null),
        assert(map['announcementID'] != null),
        assert(map['content'] != null),
        assert(map['created'] != null),
        assert(map['visible'] != null),
        firstName = map['firstName'],
        lastName = map['lastName'],
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
