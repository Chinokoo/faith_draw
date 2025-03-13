// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:draw_app/features/draw/models/customOffset.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

part 'stroke.g.dart';

@HiveType(typeId: 1)
class Stroke extends HiveObject {
  @HiveField(0)
  final List<CustomOffset> points;
  @HiveField(1)
  final int color;
  @HiveField(2)
  final double brushSize;

  Stroke({required points, required Color color, required this.brushSize})
    : points =
          points.map<CustomOffset>((e) => CustomOffset.fromOffset(e)).toList(),
      color = color.value;

  List<Offset> get offsetPoints => points.map((e) => e.toOffset()).toList();

  Color get strokeColor => Color(color);
}
