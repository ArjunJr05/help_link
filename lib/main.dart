// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hack/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LinkedIn Post View',
      theme: ThemeData(
        primaryColor: Color(0xFF0077B5), // LinkedIn primary color
        hintColor: Color(0xFF0077B5),
      ),
      home: HomePage(),
    );
  }
}
