import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_frontend/services/ImageService.dart';
import 'package:provider/provider.dart';

import 'canvas/WidgetSize.dart';
import 'canvas/CanvasProvider.dart';
import 'canvas/Draw.dart';
import 'main.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {

    CanvasProvider canvasProvider = Provider.of<CanvasProvider>(context, listen: false);

    return Scaffold(
        appBar: getAppBar(canvasProvider),
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
              Expanded(
                child: Stack(
                  children: [
                    Draw(),
                    getBackspaceButton(canvasProvider)
                  ],
                )
              )
            ),
            getBottomPanel(canvasProvider)
          ],
        )
    );
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
  
  getNextCanvasWidget(CanvasProvider canvasProvider) {
    if (canvasProvider.curList != canvasProvider.pointsLists.length - 1) {
      return getNextButton(canvasProvider);
    } else {
      return getAddCanvasButton(canvasProvider);
    }
  }
  
  getNextButton(CanvasProvider canvasProvider) {
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
  }

  getAddCanvasButton(CanvasProvider canvasProvider) {
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

  getSaveButton(CanvasProvider canvasProvider) {
    return GestureDetector(
        onTap: () async {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) {
                return Dialog(
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        // The loading indicator
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 15,
                        ),
                        // Some text
                        Text('Loading...')
                      ],
                    ),
                  ),
                );
              }
          );
          try {
            await ImageService.getFile(
                canvasProvider.width, canvasProvider.height,
                canvasProvider.pointsLists);
          } on TimeoutException {
            var snackBar = SnackBar(
              content: Text('Время ожидания истекло. Попробуйте еще раз'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } on SocketException {
            var snackBar = SnackBar(
              content: Text('Отсутствует подключение к сети'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } catch (exc) {
            var snackBar = SnackBar(
              content: Text(exc.toString().substring(11)),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          Navigator.of(context).pop();
        },
        child: Icon(
          Icons.save_alt,
          size: 30.0,
        )
    );
  }

  getAppBar(CanvasProvider canvasProvider) {
    return AppBar(
      title: Text(widget.title),
      actions: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 25.0),
            child: getSaveButton(canvasProvider)
        )
      ],
    );
  }

  getBackspaceButton(CanvasProvider canvasProvider) {
    return Container(
      margin: const EdgeInsets.only(right: 5.0, bottom: 5.0),
      child: Align(
        alignment: AlignmentDirectional.bottomEnd,
        child: IconButton(
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
    );
  }

  getBottomPanel(CanvasProvider canvasProvider) {
    return Row(
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
    );
  }
}