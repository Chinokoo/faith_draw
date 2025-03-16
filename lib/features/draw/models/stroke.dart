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

  Stroke({required this.points, required this.color, required this.brushSize});

  Color get strokeColor => Color(color);

  List<Offset> get offsetPoints => points.map((e) => e.toOffset()).toList();

  factory Stroke.fromOffsets({
    required List<Offset> points,
    required Color color,
    required double brushSize,
  }) {
    return Stroke(
      points: points.map((e) => CustomOffset.fromOffset(e)).toList(),
      color: color.value,
      brushSize: brushSize,
    );
  }
}
