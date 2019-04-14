import 'package:intro_slider/intro_slider.dart';
import 'package:flutter/material.dart';
import 'package:bagcndemo/Style/customColors.dart';
//https://medium.com/flutterpub/setting-intro-slider-screen-in-fastest-way-adc8c6c145c4

class SuperWalkthrough extends StatefulWidget {
  @override
  _SuperWalkthrough createState() {
    return _SuperWalkthrough();
  }
}

class _SuperWalkthrough extends State<SuperWalkthrough> {
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
      title: "Creating Your Class",
      description: "To get started tap the add button (or "'"Manage Classes"'" button) and select your class.",
      backgroundColor: CustomColors.bagcOrange,
      pathImage: "assets/SuperWalkthrough/ManageClasses.png"
    ),
  );
  slides.add(
    new Slide(
      marginTitle: EdgeInsets.all(0),
      description: "Create a 6 character passcode to open the class. Give your students this passcode during your program. This will be how children enter your class.",
      backgroundColor: CustomColors.bagcRed,
      pathImage: "assets/SuperWalkthrough/Passcode.png",
      widthImage: 325,
      heightImage: 325,
    ),
  );
   slides.add(
    new Slide(
      title: "Managing Your Class",
      description: "As students are joining your class, make sure to verify that these children are in your program.",
      backgroundColor: CustomColors.bagcTeal,
      pathImage: "assets/SuperWalkthrough/Verify.png"
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