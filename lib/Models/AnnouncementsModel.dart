import 'package:cloud_firestore/cloud_firestore.dart';

//class used for mapping of announcements query --> essentially has fields initialized and then mapped to their field in the database
class Announcements {
  final String id;
  final String clsName;
  final String title;
  final String description;
  final DateTime created;
  final int code;
  final DocumentReference reference;

  Announcements.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['class'] != null),
        assert(map['description'] != null),
        assert(map['id'] != null),
        assert(map['title'] != null),
        assert(map['created'] != null),
        assert(map['code'] != null),
        id = reference.documentID,
        code = map['code'],
        clsName = map['class'],
        title = map['title'],
        created = map['created'],
        description = map['description'];

  Announcements.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$clsName:$title>";
}