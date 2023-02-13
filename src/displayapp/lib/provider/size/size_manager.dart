import 'package:flutter/material.dart';

class SizeManager {
  static late double _width;
  static late double _height;

  static void init(Size size) {
    _width = size.height;
    _height = size.width;
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
}
