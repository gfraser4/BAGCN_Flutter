import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bagcndemo/Announcements/announcementLogic.dart';
import 'package:bagcndemo/Models/AnnouncementsModel.dart';


//Like Button
class LikeButton extends StatelessWidget {
  const LikeButton({
    Key key,
    @required this.announcements,
    @required this.user,
  }) : super(key: key);

  final Announcements announcements;
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          announcements.likedUsers.contains(user.uid) == true
              ? IconButton(
                  icon: Icon(Icons.thumb_up),
                  color: Color(0xFF1ca5e5),
                  onPressed: () {
                    AnnouncementLogic.likeButtonClick(user, announcements);
                  },
                )
              : IconButton(
                  icon: Icon(Icons.thumb_up),
                  color: Colors.grey,
                  onPressed: () {
                    AnnouncementLogic.likeButtonClick(user, announcements);
                  },
                ),
          announcements.likedUsers.contains(user.uid) == true
              ? Text(
                  announcements.likes.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1ca5e5),
                  ),
                )
              : Text(announcements.likes.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ))
        ],
      ),
    );
  }
}