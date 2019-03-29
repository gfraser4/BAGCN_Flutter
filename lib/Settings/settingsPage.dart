import 'package:bagcndemo/Comments/commentsLogic.dart';
import 'package:bagcndemo/Models/ClassesModel.dart';
import 'package:bagcndemo/Models/Users.dart';
import 'package:bagcndemo/Settings/SettingLogic.dart';
// import 'package:bagcndemo/Settings/editProfile.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(this.user,this.loginUser,this.classes);
  final FirebaseUser user;
  final Users loginUser;
  final List<Classes> classes;
  @override
  _SettingsPage createState() => new _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {

@override
  void initState() {
    super.initState();
    pickerColor = hexToColor(widget.loginUser.profileColor);
  }

TextEditingController passcode = new TextEditingController();
Color pickerColor;

ListTile _editProfile(){
  return ListTile(
        title: Text("Current User"),
        subtitle: Text(widget.loginUser.firstName+" "+widget.loginUser.lastName,maxLines: 1,overflow: TextOverflow.ellipsis,),
        // trailing: Icon(Icons.chevron_right),
        // onTap: (){
        //   showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return _enterPassword(1);
        //     }
        //   );
        // },
      );
    } 
    
ListTile _changePassword(){
  return ListTile(
        title: Text("Password"),
        subtitle: Text("Reset your password"),
        trailing: Icon(Icons.chevron_right),
        onTap: (){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return MyDialogContent(widget.user);
              return MyDialogContent();
            }
          );
        },
      );
    } 

// CheckboxListTile _darkMode(){
//   return CheckboxListTile(
//         title: Text("Dark Mode"),
//         value: Theme.of(context).brightness == Brightness.dark? true: false,
//         activeColor: Color.fromRGBO(123, 193, 67, 1),
//         onChanged:(bool){
//           DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.dark? Brightness.light: Brightness.dark);
//         },
//       );
//     } 

ListTile _changeProfileColour(){
  return ListTile(
        title: Text("Profile Color"),
        subtitle: Text("Pick a color as your avatar's background"),
        trailing: CircleColor (color: pickerColor,circleSize: 40),
        onTap: (){
          showDialog(
            context: context,
            child: AlertDialog(
              title: const Text('Pick A Color',style: TextStyle(
                          fontSize: 30,
                          fontStyle: FontStyle.normal,
                          color: Color.fromRGBO(0, 162, 162, 1)),),
              content: SingleChildScrollView(
              child:MaterialColorPicker(
                allowShades: false, // default true
                onMainColorChange: (Color color) {
                    pickerColor = Color(color.value);
                },
                selectedColor: pickerColor
              )
              ),
              actions: <Widget>[
                FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    SettingLogic.changeProfileColour(widget.loginUser,pickerColor.toString());
                    setState((){});
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    } 

    ListTile _muteNotification(){
      return ListTile(
            title: Text("Notification Status"),
            subtitle: Text("Mute or un-mute notification alert"),
            trailing: Icon(Icons.chevron_right),
            onTap:(){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Notification',
                      style: TextStyle(
                          fontSize: 30,
                          fontStyle: FontStyle.normal,
                          color: Color.fromRGBO(0, 162, 162, 1)),
                    ),
                    content: Text(
                      "Mute or Unmute all the classes' notification?",
                      style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                          color: Color.fromRGBO(0, 162, 162, 1)),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text("Mute All"),
                        onPressed: () {
                          SettingLogic.muteNotification(widget.user, widget.classes, true);
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text("Unmute All"),
                        onPressed: () {
                          SettingLogic.muteNotification(widget.user, widget.classes, false);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                }
              );
            } ,
          );
        } 

    ListView settingPage(){
      return ListView(
      padding: EdgeInsets.zero,
      children:<Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey))
          ),
          child: _editProfile()
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey))
          ),
          child: _changeProfileColour()
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey))
          ),
          child: _changePassword()
        ),
        // Container(
        //   decoration: BoxDecoration(
        //     border: Border(bottom: BorderSide(color: Colors.grey))
        //   ),
        //   child: _darkMode()
        // ),
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey))
          ),
          child: _muteNotification()
        ),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile Settings")),
      body: settingPage()
    );
  }
}

