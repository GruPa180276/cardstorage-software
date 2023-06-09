import 'package:flutter/material.dart';

class SizeManager {
  static late Orientation _orientation;
  static late double _width;
  static late double _height;

  void init(Size size, Orientation orientation) {
    _orientation = orientation;
    if (orientation == Orientation.portrait) {
      _width = size.width;
      _height = size.height;
    } else {
      _width = size.height;
      _height = size.width;
    }
  }

  static fs(var i) {
    return _height / 100 * i;
  }

  static ws(var i) {
    return _width / 100 * i;
  }

  static hs(var i) {
    return _height / 100 * i;
  }

  static get orientation => _orientation;
}
