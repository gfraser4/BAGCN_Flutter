import 'package:cloud_firestore/cloud_firestore.dart';


class CreateAnnouncementLogic {

static void createAnnouncement(int code, String className, String title, String description, DateTime nowTime ){
var newAnnouncement = Firestore.instance
                      .collection('announcements').document();
                      
                  newAnnouncement
                    .setData({ 
                    'id': newAnnouncement.documentID,  
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


