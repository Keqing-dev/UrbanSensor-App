import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:urbansensor/src/utils/palettes.dart';

class LoadingIndicatorsC {
  static Widget ballRotateChaseExpanded = Expanded(
    child: SizedBox(
      height: 222,
      child: Center(
        child: SizedBox(
          height: 100,
          child: LoadingIndicator(
            indicatorType: Indicator.ballRotateChase,
            colors: [
              Palettes.gray2,
              Colors.lightBlue,
            ],
          ),
        ),
      ),
    ),
  );

  static Widget ballScale = Center(
    child: SizedBox(
      height: 100,
      child: LoadingIndicator(
        indicatorType: Indicator.ballScale,
        colors: [Palettes.gray2, Colors.lightBlue],
      ),
    ),
  );

  static Widget ballRotateChase = Center(
    child: SizedBox(
      height: 100,
      child: LoadingIndicator(
        indicatorType: Indicator.ballRotateChase,
        colors: [Palettes.gray2, Colors.lightBlue],
      ),
    ),
  );

  static Widget ballRotateChaseSmall = Center(
    child: SizedBox(
      height: 50,
      child: LoadingIndicator(
        indicatorType: Indicator.ballRotateChase,
        colors: [Palettes.gray2, Colors.lightBlue],
      ),
    ),
  );
}
