import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'splash_screen.dart';

void main() {
  runApp(
    MyApp(),
    
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product & Wallpaper App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: SplashScreen(),
    );
  }
}
