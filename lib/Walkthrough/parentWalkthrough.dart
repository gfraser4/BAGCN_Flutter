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
      description: "Hello World!",
      backgroundColor: CustomColors.bagcGreen,
    ),
  );
  slides.add(
    new Slide(
      title: "Ipsum Lorem",
      description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed scelerisque nunc massa, id mattis ligula tincidunt eget. Curabitur ultrices urna velit, ac ultrices est aliquam eget. Aliquam vel quam erat. Fusce sollicitudin est vel tortor lacinia malesuada at quis turpis. Integer semper neque et massa lacinia blandit.",
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