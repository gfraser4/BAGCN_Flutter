import 'package:cloud_firestore/cloud_firestore.dart';

class Classes {
  final String clsName;
  final String location;
  final String dates;
  final String times;
  final int code;
  final bool isActive;
  final List<dynamic> enrolledUsers;
  final List<dynamic> pendingUsers;
  final List<dynamic> supervisors;
  final List<dynamic> notifyUsers;
  final DocumentReference reference;

  Classes.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['clsName'] != null),
        assert(map['code'] != null),
        assert(map['dates'] != null),
        assert(map['times'] != null),
        assert(map['location'] != null),
        clsName = map['clsName'],
        isActive = map['isActive'],
        enrolledUsers = map['enrolledUsers'],
        supervisors = map['supervisors'],
        notifyUsers = map['notifyUsers'],
        pendingUsers = map['pendingUsers'],
        location = map['location'],
        dates = map['dates'],
        times = map['times'],
        code = map['code'];

  Classes.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$clsName:$code>";
}