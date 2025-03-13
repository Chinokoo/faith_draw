import 'dart:math';
import 'package:draw_app/features/draw/models/stroke.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

//list of suggested drawings a kid should draw
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

// getting a randow drawing string
Random _random = Random();
String randomDrawString = "";

class _DrawingPageState extends State<DrawingPage> {
  //drawing points
  List<Stroke> _strokes = [];
  List<Stroke> _redoStrokes = [];
  List<Offset> _currentPoints = [];
  Color _selectedColor = const Color.fromRGBO(0, 0, 0, 1);
  double _brushSize = 4.0;
  //for saving to hive
  late Box<List<Stroke>> _drawingBox;

  @override
  void initState() {
    _initializeBox();
    super.initState();
    randomDrawString = drawlist[_random.nextInt(drawlist.length)];
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  //intialising the hive box
  _initializeBox() {
    _drawingBox = Hive.box<List<Stroke>>("drawings");
  }

  //save function

  //show dialog function to save the drawing
  void _showSaveDialog() {
    final TextEditingController _controller = TextEditingController(
      text: randomDrawString,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 151, 14, 60),
          title: Center(
            child: const Text(
              "Save Drawing",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {},
              child: Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  //the drawing page
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
                  "Draw: ",
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
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 40.0),
        child: FloatingActionButton(
          onPressed: () {
            _showSaveDialog();
          },
          tooltip: "save drawing",
          child: Icon(Icons.download),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  //the tool bar behind the page
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

  //the color buttons
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

//the painting canvas
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
            ..color = stroke.strokeColor
            ..strokeCap = StrokeCap.round
            ..strokeWidth = stroke.brushSize;

      //final points = stroke.offsetPoints; can also use this but nahhhhh!
      for (int i = 0; i < stroke.offsetPoints.length - 1; i++) {
        if (stroke.offsetPoints[i] != Offset.zero &&
            stroke.offsetPoints[i + 1] != Offset.zero) {
          canvas.drawLine(
            stroke.offsetPoints[i],
            stroke.offsetPoints[i + 1],
            paint,
          );
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
