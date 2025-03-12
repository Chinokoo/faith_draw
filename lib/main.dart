import 'package:draw_app/features/draw/presentation/draw.dart';
import 'package:draw_app/features/home/presentation/home.dart';
import 'package:draw_app/features/splash/presentation/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Draw your favorite bible characters",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashScreen(),
        "/home": (context) => const HomePage(),
        "/draw": (context) => DrawingPage(),
      },
    );
  }
}
