import 'package:flutter/material.dart';

import 'services/ImageService.dart';
import 'canvas/Painter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(title: 'супер пупер приложение'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    double canvasHeight = 0;
    double canvasWidth = 0;

    var appBar = AppBar(
      title: Text(widget.title),
    );

    var customPaint = CustomPaint(
          child: Container(
            height: () {
              canvasHeight = (MediaQuery.of(context).size.height - appBar.preferredSize.height) * 0.85;
              return canvasHeight;
            }.call(),

            width: () {
              canvasWidth = MediaQuery.of(context).size.width;
              return canvasWidth;
            }.call(),

            color: Colors.black,
          ),
    foregroundPainter: Painter(),
    );

    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
        CustomPaint(
          child: customPaint,
          foregroundPainter: Painter(),
        ),
        OutlinedButton(
            onPressed: () {
              ImageService.createImage(canvasWidth, canvasHeight);
            },
            child: const Text('Сохранить'))
        ],
      )
    );
  }
}
