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
      description: "To get started tap the "'"Add a Child"'" Button and enter a nickname or first name.",
      backgroundColor: CustomColors.bagcBlue,
    ),
  );
   slides.add(
    new Slide(
      title: "Adding A Class",
      description: "Select "'"Manage Classes"'" and search for your class. Your program supervisor will verify and send you the passcode.",
      backgroundColor: CustomColors.bagcGreen,
    ),
  );
  }

  void onDonePress() {
    Navigator.of(context).pop();
  }

  void onSkipPress() {
    Navigator.of(context).pop();
  }


  @override  
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
      onSkipPress: this.onSkipPress,
    );
  }
}