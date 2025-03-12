// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/widgets.dart';

class Stroke {
  final List<Offset> points;
  final Color color;
  final double brushSize;

  Stroke({required this.points, required this.color, required this.brushSize});
}
