import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Card(
                  color: Colors.lightGreen[100],
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(20.0),
                        child: Image.asset('assets/BGC_Niagara_logo.png'),
                      ),
                      
                      Text(
                        '\n\nWelcome to the Boys and Girls Club Messaging App. This app allows you to stay up to date with the latest anouncements based on your specific class enrollment. It also allows yur to quickly communicate with the instructor.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
