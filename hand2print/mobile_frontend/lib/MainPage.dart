import 'dart:async';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_frontend/services/ImageService.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'canvas/WidgetSize.dart';
import 'canvas/CanvasProvider.dart';
import 'canvas/Draw.dart';
import 'canvas/Coords.dart';
import 'canvas/ResizebleWidget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<List<Widget>> children = [];
  int current_state = -1;
  Coords coords = Coords();
  File? file;

  @override
  Widget build(BuildContext context) {

    CanvasProvider canvasProvider = Provider.of<CanvasProvider>(
        context, listen: false);
    if (current_state == -1) {
      current_state = 0;
      children.add([
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
      ]);
    }

    return Scaffold(
        appBar: getAppBar(canvasProvider),
        body: Column(
          children: children[current_state],
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
              if (canvasProvider.curList > 0) {
                canvasProvider.curList--;
                children.clear();
                current_state = -1;
              };
            });
          },
        ),
        Text(
            (canvasProvider.curList + 1).toString() + "/",
            style: TextStyle(
                fontSize: 30,
                color: Theme.of(context).colorScheme.primary)),
        Text(
            canvasProvider.pointsLists.length.toString(),
            style: TextStyle(
                fontSize: 30,
                color: Theme.of(context).colorScheme.primary)),
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
          if (canvasProvider.curList < canvasProvider.pointsLists.length - 1) {
            canvasProvider.curList++;
            children.clear();
            current_state = -1;
          }
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
          canvasProvider.imagesLists.add([]);
          canvasProvider.coordsLists.add([]);
          canvasProvider.curList = canvasProvider.pointsLists.length - 1;
          children.clear();
          current_state = -1;
        });
      },
    );
  }

  _getFromCamera(CanvasProvider canvasProvider) async {
    PickedFile? pickedFile = await await ImagePicker.platform.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        file = File(pickedFile.path);
        current_state = 1;
        children.insert(
            current_state,
            [
              Expanded(
                child: ResizebleWidget(
                    child: Container(
                      child: Image.file(
                          file!,
                          fit: BoxFit.fill),
                      width: 100,
                      height: 100,
                    ),
                    coords: coords,
                  )
              ),
              getUploadPanel(canvasProvider)
            ]
        );
      });
    }
  }

  getUploadButton(CanvasProvider canvasProvider) {
    return IconButton(
      icon: Icon(
        Icons.photo_camera_outlined,
        color: Colors.white,
        size: 30.0,
      ),
      onPressed: () {
        _getFromCamera(canvasProvider);
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
                canvasProvider.width,
                canvasProvider.height,
                canvasProvider.pointsLists,
                canvasProvider.imagesLists,
                canvasProvider.coordsLists);
          } on TimeoutException {
            var snackBar = SnackBar(
              content: Text('The timeout has expired'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } on SocketException {
            var snackBar = SnackBar(
              content: Text('No network connection'),
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
            padding: EdgeInsets.only(right: 20.0),
            child: getUploadButton(canvasProvider)
        ),
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
              int pointCountToRemove = min(
                  canvasProvider.pointsLists[canvasProvider.curList].length, 5);
              int listLength = canvasProvider.pointsLists[canvasProvider.curList].length;
              canvasProvider.pointsLists[canvasProvider.curList].removeRange(
                  listLength - pointCountToRemove, listLength - 1);
            });
          },
        ),
      ),
    );
  }

  Future<ui.Image> loadImage(File imageFile, Coords coords) async {
    Uint8List img = Uint8List.fromList(imageFile.readAsBytesSync());
    final codec = await ui.instantiateImageCodec(
      img,
      targetHeight: coords.height.toInt(),
      targetWidth: coords.width.toInt(),
    );
    return (await codec.getNextFrame()).image;
  }

  getUploadPanel(CanvasProvider canvasProvider) {
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
              current_state = 0;
              children[1] = [];
            });
          },
        ),
        IconButton(
          icon: Icon(
            CupertinoIcons.check_mark,
            color: Theme.of(context).colorScheme.primary,
            size: 35.0,
          ),
          onPressed: () async {
            ui.Image image = await loadImage(file!, coords);
            setState(()  {
              current_state = 0;
              canvasProvider.imagesLists[canvasProvider.curList].add(image);
              canvasProvider.coordsLists[canvasProvider.curList].add(coords);
              coords = Coords();
              children[1] = [];
            });
          },
        ),
      ],
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
                canvasProvider.imagesLists.removeAt(canvasProvider.curList);
                canvasProvider.coordsLists.removeAt(canvasProvider.curList);
                if (canvasProvider.curList > 0) {
                  canvasProvider.curList--;
                }
              } else {
                canvasProvider.pointsLists[canvasProvider.curList].clear();
                canvasProvider.imagesLists[canvasProvider.curList].clear();
                canvasProvider.coordsLists[canvasProvider.curList].clear();
              }
              current_state = -1;
              children.clear();
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
              canvasProvider.imagesLists[canvasProvider.curList].clear();
              canvasProvider.coordsLists[canvasProvider.curList].clear();
              current_state = -1;
              children.clear();
            });
          },
        ),
      ],
    );
  }
}