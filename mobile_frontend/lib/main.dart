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

    CanvasProvider canvasProvider = Provider.of<CanvasProvider>(context, listen: false);

    var appBar = AppBar(
      title: Text(widget.title),
    );

    canvasProvider.appBarHeight = appBar.preferredSize.height;

    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          Draw(),
          OutlinedButton(
            onPressed: () {
              ImageService.createImage(canvasProvider.width, canvasProvider.height, canvasProvider.pointsLists);
            },
            child: const Text('Сохранить')
          ),
          OutlinedButton(
            onPressed: () {
              canvasProvider.pointsLists[canvasProvider.curList].clear();
            },
            child: const Text('Очистить')
          ),
          OutlinedButton(
            onPressed: () {
              setState(() {
                canvasProvider.pointsLists.add([]);
                canvasProvider.curList = canvasProvider.pointsLists.length - 1;
              });
            },
            child: const Text('Добавить канвас')
          ),
          OutlinedButton(
              onPressed: () {
                setState(() {
                  if (canvasProvider.pointsLists.length > 0) {
                    canvasProvider.pointsLists.removeAt(canvasProvider.curList);
                    if (canvasProvider.curList > 0) canvasProvider.curList--;
                  }
                });
              },
              child: const Text('Удалить канвас')
          ),
          OutlinedButton(
            onPressed: () {
              setState(() {
                if (canvasProvider.curList > 0) canvasProvider.curList--;
              });
            },
            child: const Text('Предыдущий канвас')
          ),
          OutlinedButton(
            onPressed: () {
              setState(() {
                if (canvasProvider.curList < canvasProvider.pointsLists.length - 1) canvasProvider.curList++;
              });
            },
            child: const Text('Следующий канвас')
          ),
          Text((canvasProvider.curList + 1).toString()),
          Text(canvasProvider.pointsLists.length.toString())
        ],
      )
    );

  }

}

class CanvasProvider extends ChangeNotifier {
  double width = 0;
  double height = 0;
  double appBarHeight = 0;

  List<List<DrawingPoints>> pointsLists = [[]];
  int curList = 0;

  void setWidth(double value) {
    width = value;
  }

  void setHeight(double value) {
    height = value;
  }
}