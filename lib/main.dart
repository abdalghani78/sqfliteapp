import 'package:flutter/material.dart';
import 'widget/home.dart';


void main()
{
  runApp(const RunApp());
}

class RunApp extends StatelessWidget {
  const RunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

