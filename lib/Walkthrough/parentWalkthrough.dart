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
      description: "Test",
      backgroundColor: CustomColors.bagcGreen,
    )
  );
  }

  void onDonePress() {
    // Do what you want
  }

  void onSkipPress() {
    // Do what you want
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