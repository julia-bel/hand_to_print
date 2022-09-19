import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'canvas/Draw.dart';
import 'services/ImageService.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => CanvasProvider(),
      child: MyApp()));
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
      home: const MyHomePage(title: 'Hand To Print'),
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

    CanvasProvider canvasProvider = Provider.of<CanvasProvider>(context);

    var appBar = AppBar(
      title: Text(widget.title),
    );

    canvasProvider.appBarHeight = appBar.preferredSize.height;
    log(canvasProvider.appBarHeight.toString());
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          Draw(),
          OutlinedButton(
              onPressed: () {
                ImageService.createImage(canvasProvider.width, canvasProvider.height, canvasProvider.pointsList);
              },
              child: const Text('Сохранить')
          ),
          OutlinedButton(
              onPressed: () {
                canvasProvider.pointsList.clear();
              },
              child: const Text('Очистить')
          )
        ],
      )
    );

  }

}

class CanvasProvider extends ChangeNotifier {
  double width = 0;
  double height = 0;
  double appBarHeight = 0;
  List<DrawingPoints> pointsList = [];

  void setWidth(double value) {
    width = value;
  }

  void setHeight(double value) {
    height = value;
  }
}