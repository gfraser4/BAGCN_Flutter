import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
                child: Column(
                  children: <Widget>[
                    new LogoArea(),
                    new BAGCNAppDescription(),
                    SizedBox(height: 20),
                    new BAGCNHyperLink(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// HYPERLINK AREA
class BAGCNHyperLink extends StatelessWidget {
  const BAGCNHyperLink({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text('www.boysandgirlsclubniagara.org',
          style: TextStyle(
              color: Color.fromRGBO(28, 165, 229, 1),
              fontSize: 20)),
      onTap: () async {
        if (await canLaunch(
            "https://www.boysandgirlsclubniagara.org/")) {
          await launch(
              "https://www.boysandgirlsclubniagara.org/");
        }
      },
    );
  }
}

// APP DESCRIPTION
class BAGCNAppDescription extends StatelessWidget {
  const BAGCNAppDescription({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Text(
        '\n\nWelcome to the Boys and Girls Club Messaging App. This app allows you to stay up to date with the latest anouncements based on your specific class enrollment. It also allows you to quickly communicate with the instructor.',
        style: TextStyle(fontSize: 18, color: Colors.black87),
        textAlign: TextAlign.justify,
      ),
    );
  }
}

// LOGO AREA
class LogoArea extends StatelessWidget {
  const LogoArea({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 30.0, vertical: 8.0),
      margin: EdgeInsets.all(20.0),
      child: Image.asset('assets/BGC_Niagara_logo.png'),
    );
  }
}
