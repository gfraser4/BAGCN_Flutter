import 'package:cloud_firestore/cloud_firestore.dart';

//CLASS MAP BASED ON FIRESTORE ANNOUNCEMENT TABLE
class Replies {
  final String userID;
  final String parentCommentID;
  final String replyID;
  final String firstName;
  final String lastName;
  final String content;
  final DateTime created;
  final bool visible;
  final DocumentReference reference;

  Replies.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['firstName'] != null),
        assert(map['lastName'] != null),
        assert(map['userID'] != null),
        assert(map['parentCommentID'] != null),
        assert(map['replyID'] != null),
        assert(map['content'] != null),
        assert(map['created'] != null),
        assert(map['visible'] != null),
        userID = map['userID'],
        firstName = map['firstName'],
        lastName = map['lastName'],
        parentCommentID = map['parentCommentID'],
        replyID = map['replyID'],
        content = map['content'],
        visible = map['visible'],
        created = map['created'];

  Replies.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  // @override
  // String toString() => "Record<$clsName:$title>";
}
