import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Drawings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 151, 14, 60),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Start Drawing",
        onPressed: () {
          Navigator.pushNamed(context, "/draw");
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
