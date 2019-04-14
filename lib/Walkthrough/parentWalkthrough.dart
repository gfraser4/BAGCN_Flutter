import 'package:intro_slider/intro_slider.dart';
import 'package:flutter/material.dart';
import 'package:bagcndemo/Style/customColors.dart';
//https://medium.com/flutterpub/setting-intro-slider-screen-in-fastest-way-adc8c6c145c4

class ParentWalkthrough extends StatefulWidget {
  @override
  _ParentWalkthrough createState() {
    return _ParentWalkthrough();
  }
}

class _ParentWalkthrough extends State<ParentWalkthrough> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

  slides.add(
    new Slide(
      title: "Welcome!",
      pathImage: 'assets/BGC_Niagara_Vertical.png',
      maxLineTitle: 5,
      description: "Before you start, we would like to show a few things.",
      backgroundColor: Colors.blueGrey,
    ),
  );
  slides.add(
    new Slide(
      title: "Creating A Child Profile",
      description: "To get started tap the "'"Add a Child"'" button and enter a nickname or first name for your child/children.",
      pathImage: "assets/ParentWalkthrough/AddChild.png",
      backgroundColor: CustomColors.bagcBlue,
    ),
  );
   slides.add(
    new Slide(
      title: "Adding A Class",
      description: "Select "'"Manage Classes"'" and search for your class. Your program supervisor will verify and send you the passcode.",
      pathImage: "assets/ParentWalkthrough/ManageClasses.png",
      backgroundColor: CustomColors.bagcOrange,
    ),
  );
  slides.add(
    new Slide(
      title: "Your Home Page",
      description: "In the "'"Lastest News"'" section, you will be able to see global announcements.",
      pathImage: "assets/ParentWalkthrough/LatestNews.png",
      backgroundColor: CustomColors.bagcGreen,
    ),
  );
  slides.add(
    new Slide(
      description: "In the "'"My Kids"'" section, you can check class annoucements for the classes your child is participating in.",
      pathImage: "assets/ParentWalkthrough/MyKids.png",
      backgroundColor: CustomColors.bagcRed,
    ),
  );
  }

  void onDonePress() {
    Navigator.of(context).pop();
  }

  void onSkipPress() {
  }


  @override  
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
    );
  }
}