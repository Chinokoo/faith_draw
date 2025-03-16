import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box _drawingBox;
  bool _isLoading = true;

  Future<void> _initializeHive() async {
    // Check if the box is already open
    if (Hive.isBoxOpen("drawings")) {
      //await Hive.deleteBoxFromDisk("drawings");
      _drawingBox = await Hive.box("drawings");
    } else {
      // Open the box if it's not already open
      _drawingBox = await Hive.openBox("drawings");
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _deleteDrawing(String name) {
    _drawingBox.delete(name);
    setState(() {});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Drawing $name is deleted!",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  //show dialog function to save the drawing
  void _showDeleteDialog(String name) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 151, 14, 60),
          title: Center(
            child: Text(
              "Delete ${name}",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Text(
            "Are You sure you want to delete this drawing?",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                _deleteDrawing(name);
                Navigator.pop(context);
              },
              child: Text("Delete", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    setState(() {});
    _initializeHive(); // Start the initialization process
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while Hive is initializing
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "My Drawings",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 151, 14, 60),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Once loaded, show the actual content
    final drawingNames = _drawingBox.keys.cast<String>().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Drawings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 151, 14, 60),
      ),
      body:
          drawingNames.isEmpty
              ? const Center(
                child: Text(
                  "No Drawings Available !",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 151, 14, 60),
                  ),
                ),
              )
              : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: drawingNames.length,
                itemBuilder: (context, index) {
                  final name = drawingNames[index];
                  final data = _drawingBox.get(name) as Map;
                  final thumbnail = data['thumbnail'] as Uint8List;
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/draw", arguments: name);
                      setState(() {});
                    },
                    child: Stack(
                      children: [
                        Card(
                          elevation: 4,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Image.memory(
                                    thumbnail,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: 4,
                          child: IconButton(
                            onPressed: () {
                              _showDeleteDialog(name);
                            },
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Start Drawing",
        onPressed: () {
          Navigator.pushNamed(context, "/draw");
          setState(() {});
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Icon(
          Icons.edit,
          size: 20,
          color: const Color.fromARGB(255, 151, 14, 60),
        ),
      ),
    );
  }
}
