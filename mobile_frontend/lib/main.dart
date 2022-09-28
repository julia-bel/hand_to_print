import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'WidgetSize.dart';
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
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.pink[700],
        ),
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
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 25.0),
          child: GestureDetector(
            onTap: () {
              ImageService.createImage(canvasProvider.width, canvasProvider.height, canvasProvider.pointsLists);
            },
            child: Icon(
              Icons.save_alt,
              size: 30.0,
            ),
          )
        )
      ],
    );

    canvasProvider.appBarHeight = appBar.preferredSize.height;

    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          WidgetSize(
            onChange: (Size size) {
              setState(() {
                canvasProvider.height = size.height;
                canvasProvider.width = size.width;
              });
            },
            child:
              Expanded(child:
                Stack(
                  children: [
                    Draw(),
                    Container(
                      margin: const EdgeInsets.only(right: 5.0, bottom: 5.0),
                      child:
                        Align(
                          alignment: AlignmentDirectional.bottomEnd,
                          child:   IconButton(
                            icon: Icon(
                              Icons.backspace_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              size: 35.0,
                            ),
                            onPressed: () {
                              setState(() {
                                int pointCountToRemove = min(canvasProvider.pointsLists[canvasProvider.curList].length, 5);
                                int listLength = canvasProvider.pointsLists[canvasProvider.curList].length;
                                canvasProvider.pointsLists[canvasProvider.curList].removeRange(listLength - pointCountToRemove, listLength - 1);
                              });
                            },
                          ),
                        ),
                    )
                  ],
                )
              )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  CupertinoIcons.delete,
                  color: Theme.of(context).colorScheme.primary,
                  size: 35.0,
                ),
                onPressed: () {
                  setState(() {
                    if (canvasProvider.pointsLists.length > 1) {
                      canvasProvider.pointsLists.removeAt(canvasProvider.curList);
                      if (canvasProvider.curList > 0) canvasProvider.curList--;
                    }
                  });
                },
              ),
              Container(
                  child: getSwitchCanvasWidget(canvasProvider)
              ),
              IconButton(
                icon: Icon(
                  CupertinoIcons.clear,
                  color: Theme.of(context).colorScheme.primary,
                  size: 35.0,
                ),
                onPressed: () {
                  setState(() {
                    canvasProvider.pointsLists[canvasProvider.curList].clear();
                  });
                },
              ),
            ],
          ),
        ],
      )
    );
  }
  
  getNextCanvasWidget(CanvasProvider canvasProvider) {
    if (canvasProvider.curList != canvasProvider.pointsLists.length - 1) {
      return IconButton(
        icon: Icon(
          CupertinoIcons.right_chevron,
          color: Theme
              .of(context)
              .colorScheme.primary,
          size: 40.0,
        ),
        onPressed: () {
          setState(() {
            if (canvasProvider.curList <
                canvasProvider.pointsLists.length - 1) canvasProvider.curList++;
          });
        },
      );
    } else {
      return IconButton(
        icon: Icon(
          CupertinoIcons.add_circled,
          color: Theme
              .of(context)
              .colorScheme.primary,
          size: 35.0,
        ),
        onPressed: () {
          setState(() {
            canvasProvider.pointsLists.add([]);
            canvasProvider.curList = canvasProvider.pointsLists.length - 1;
          });
        },
      );
    }
  }

  getSwitchCanvasWidget(CanvasProvider canvasProvider) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            CupertinoIcons.left_chevron,
            color: Theme.of(context).colorScheme.primary,
            size: 40.0,
          ),
          onPressed: () {
            setState(() {
              if (canvasProvider.curList > 0) canvasProvider.curList--;
            });
          },
        ),
        Text((canvasProvider.curList + 1).toString()+"/", style: TextStyle(fontSize: 30, color: Theme.of(context).colorScheme.primary)),
        Text(canvasProvider.pointsLists.length.toString(), style: TextStyle(fontSize: 30, color: Theme.of(context).colorScheme.primary)),
        getNextCanvasWidget(canvasProvider),
      ],
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