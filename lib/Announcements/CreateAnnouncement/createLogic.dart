import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAnnouncementLogic {

// CREATE ANNOUNCEMENT
static void createAnnouncement(int code, String className, String title, String description, DateTime nowTime, FirebaseUser user ){
var newAnnouncement = Firestore.instance
                      .collection('announcements').document();
                      
                  newAnnouncement
                    .setData({ 
                    'id': newAnnouncement.documentID, 
                    'postedBy' : user.uid, 
                    'code': code,
                    'commentCount': 0,
                    'class': className,
                    'title': title,
                    'description': description,
                    'created': nowTime,
                    'likes': 0,
                    'likedUsers':[],
                    'notifyUsers': [],
                  });

}

}


