import 'package:flutter/material.dart';

import 'package:bagcndemo/Announcements/announcementLogic.dart';
import 'package:bagcndemo/Models/AnnouncementsModel.dart';


//Delete Button
class DeleteButton extends StatelessWidget {
  const DeleteButton({
    Key key,
    @required this.announcements,
  }) : super(key: key);

  final Announcements announcements;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.delete,
            color: Color(0xFF1ca5e5),
          ),
          Text(
            'Delete',
            style: TextStyle(color: Color(0xFF1ca5e5)),
          )
        ],
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Delete Announcement?',
                style: TextStyle(
                    fontSize: 30,
                    fontStyle: FontStyle.normal,
                    color: Color.fromRGBO(0, 162, 162, 1)),
              ),
              content: Text(
                  'Are you sure you want to delete this announcement? This will permanently remove all associated comments.'),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("Delete"),
                  onPressed: () {
                    AnnouncementLogic.deleteAnnouncement(announcements.id);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
