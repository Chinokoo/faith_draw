import 'dart:math';
import 'package:draw_app/features/draw/models/stroke.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

List<String> drawlist = [
  "Moses and his rode",
  "Adam and eve in the garden",
  "Samson fighting a lion",
  "Daniel in the lions den",
  "Noah and the ark",
  "david and goliath",
  "Jesus on the cross",
  "Jesus and his disciples",
  "Jesus walking on water",
  "Jesus praying",
  "Jesus ascending to heaven",
  "moses and the burning bush",
];

Random _random = Random();
String randomDrawString = "";

class _DrawingPageState extends State<DrawingPage> {
  List<Stroke> _strokes = [];
  List<Stroke> _redoStrokes = [];
  List<Offset> _currentPoints = [];
  Color _selectedColor = Colors.black;
  double _brushSize = 4.0;

  @override
  void initState() {
    super.initState();
    randomDrawString = drawlist[_random.nextInt(drawlist.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Draw your Picture",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 151, 14, 60),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Draw:",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                Text(
                  randomDrawString.toUpperCase(),

                  style: TextStyle(
                    fontSize: 20,

                    color: const Color.fromARGB(255, 151, 14, 60),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  _currentPoints.add(details.localPosition);
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  _currentPoints.add(details.localPosition);
                });
              },
              onPanEnd: (details) {
                setState(() {
                  _strokes.add(
                    Stroke(
                      points: List.from(_currentPoints),
                      color: _selectedColor,
                      brushSize: _brushSize,
                    ),
                  );
                  _currentPoints = [];
                  _redoStrokes = [];
                });
              },
              child: CustomPaint(
                painter: DrawPainter(
                  strokes: _strokes,
                  currentPoints: _currentPoints,
                  currentColor: _selectedColor,
                  currentBrushSize: _brushSize,
                ),
                size: Size.infinite,
              ),
            ),
          ),
          _buildToolBar(),
        ],
      ),
    );
  }

  Widget _buildToolBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed:
                _strokes.isNotEmpty
                    ? () {
                      setState(() {
                        _redoStrokes.add(_strokes.removeLast());
                      });
                    }
                    : null,
            icon: const Icon(
              Icons.redo,
              color: const Color.fromARGB(255, 151, 14, 60),
            ),
          ),
          IconButton(
            onPressed:
                _redoStrokes.isNotEmpty
                    ? () {
                      setState(() {
                        _strokes.add(_redoStrokes.removeLast());
                      });
                    }
                    : null,
            icon: const Icon(
              Icons.undo,
              color: const Color.fromARGB(255, 151, 14, 60),
            ),
          ),
          DropdownButton(
            //dropdownColor: const Color.fromARGB(255, 151, 14, 60),
            value: _brushSize,
            dropdownColor: Colors.grey[100],
            items: [
              DropdownMenuItem(
                value: 2.0,
                child: Text(
                  "Small",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 151, 14, 60),
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 4.0,
                child: Text(
                  "Medium",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 151, 14, 60),
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 8.0,
                child: Text(
                  "Large",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 151, 14, 60),
                  ),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _brushSize = value!;
              });
            },
          ),

          //Color buttons
          Row(
            children: [
              _buildColorButton(Colors.black),
              _buildColorButton(Colors.red),
              _buildColorButton(Colors.orange),
              _buildColorButton(Colors.green),
              _buildColorButton(Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _selectedColor == color ? Colors.grey : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }
}

class DrawPainter extends CustomPainter {
  final List<Stroke> strokes;
  final List<Offset> currentPoints;
  final Color currentColor;
  final double currentBrushSize;

  DrawPainter({
    super.repaint,
    required this.strokes,
    required this.currentPoints,
    required this.currentColor,
    required this.currentBrushSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    //for previous stoke
    for (final stroke in strokes) {
      final paint =
          Paint()
            ..color = stroke.color
            ..strokeCap = StrokeCap.round
            ..strokeWidth = stroke.brushSize;
      for (int i = 0; i < stroke.points.length - 1; i++) {
        if (stroke.points[i] != Offset.zero &&
            stroke.points[i + 1] != Offset.zero) {
          canvas.drawLine(stroke.points[i], stroke.points[i + 1], paint);
        }
      }
    }
    //draw the current stoke
    final paint =
        Paint()
          ..color = currentColor
          ..strokeCap = StrokeCap.round
          ..strokeWidth = currentBrushSize;
    for (int i = 0; i < currentPoints.length - 1; i++) {
      if (currentPoints[i] != Offset.zero &&
          currentPoints[i + 1] != Offset.zero) {
        canvas.drawLine(currentPoints[i], currentPoints[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
