import 'package:cloud_firestore/cloud_firestore.dart';

// MAP OF ANNOUNCEMENTS QUERY
class Announcements {
  final String id;
  final String clsName;
  final String title;
  final String description;
  final DateTime created;
  final int code;
  final int likes;
  final int commentCount;
  final String postedBy;
  final List<dynamic> notifyUsers;
  final List<dynamic> likedUsers;
  final DocumentReference reference;

  Announcements.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['class'] != null),
      assert(map['postedBy'] != null),
        assert(map['description'] != null),
        assert(map['id'] != null),
        assert(map['title'] != null),
        assert(map['created'] != null),
        assert(map['code'] != null),
        id = reference.documentID,
        code = map['code'],
        postedBy = map['postedBy'],
        likedUsers = map['likedUsers'],
        likes = map['likes'],
        commentCount = map['commentCount'],
        notifyUsers = map['notifyUsers'],
        clsName = map['class'],
        title = map['title'],
        created = map['created'],
        description = map['description'];

  Announcements.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

}