import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'Coords.dart';


class ResizebleWidget extends StatefulWidget {
  Coords coords;

  ResizebleWidget({required this.child, required this.coords});

  final Widget child;
  @override
  _ResizebleWidgetState createState() => _ResizebleWidgetState(coords: coords);
}

const ballDiameter = 10.0;

class _ResizebleWidgetState extends State<ResizebleWidget> {
  Coords coords;

  _ResizebleWidgetState({required this.coords});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: coords.top,
          left: coords.left,
          child: Container(
            height: coords.height,
            width: coords.width,

            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 2,
                color: Colors.pink[700]!,
              ),
              borderRadius: BorderRadius.circular(0.0),
            ),

            // need tp check if draggable is done from corner or sides
            child: FittedBox(
              child: widget.child,
              fit: BoxFit.fill,
            ),
          ),
        ),
        // coords.top left
        Positioned(
          top: coords.top - ballDiameter / 2,
          left: coords.left- ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = (dx + dy) / 2;
              var newHeight = coords.height - 2 * mid;
              var newWidth = coords.width - 2 * mid;

              setState(() {
                coords.height = newHeight > 0 ? newHeight : 0;
                coords.width = newWidth > 0 ? newWidth : 0;
                coords.top = coords.top + mid;
                coords.left= coords.left+ mid;
              });
            },
            handlerWidget: HandlerWidget.VERTICAL,
          ),
        ),
        // coords.top middle
        Positioned(
          top: coords.top - ballDiameter / 2,
          left: coords.left+ coords.width / 2 - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var newHeight = coords.height - dy;

              setState(() {
                coords.height = newHeight > 0 ? newHeight : 0;
                coords.top = coords.top + dy;
              });
            },
            handlerWidget: HandlerWidget.HORIZONTAL,
          ),
        ),
        // coords.top right
        Positioned(
          top: coords.top - ballDiameter / 2,
          left: coords.left+ coords.width - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = (dx + (dy * -1)) / 2;

              var newHeight = coords.height + 2 * mid;
              var newWidth = coords.width + 2 * mid;

              setState(() {
                coords.height = newHeight > 0 ? newHeight : 0;
                coords.width = newWidth > 0 ? newWidth : 0;
                coords.top = coords.top - mid;
                coords.left= coords.left- mid;
              });
            },
            handlerWidget: HandlerWidget.VERTICAL,
          ),
        ),
        // center right
        Positioned(
          top: coords.top + coords.height / 2 - ballDiameter / 2,
          left: coords.left+ coords.width - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var newWidth = coords.width + dx;

              setState(() {
                coords.width = newWidth > 0 ? newWidth : 0;
              });
            },
            handlerWidget: HandlerWidget.HORIZONTAL,
          ),
        ),
        // bottom right
        Positioned(
          top: coords.top + coords.height - ballDiameter / 2,
          left: coords.left+ coords.width - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = (dx + dy) / 2;

              var newHeight = coords.height + 2 * mid;
              var newWidth = coords.width + 2 * mid;

              setState(() {
                coords.height = newHeight > 0 ? newHeight : 0;
                coords.width = newWidth > 0 ? newWidth : 0;
                coords.top = coords.top - mid;
                coords.left= coords.left- mid;
              });
            },
            handlerWidget: HandlerWidget.VERTICAL,
          ),
        ),
        // bottom center
        Positioned(
          top: coords.top + coords.height - ballDiameter / 2,
          left: coords.left+ coords.width / 2 - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var newHeight = coords.height + dy;

              setState(() {
                coords.height = newHeight > 0 ? newHeight : 0;
              });
            },
            handlerWidget: HandlerWidget.HORIZONTAL,
          ),
        ),
        // bottom left
        Positioned(
          top: coords.top + coords.height - ballDiameter / 2,
          left: coords.left- ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = ((dx * -1) + dy) / 2;

              var newHeight = coords.height + 2 * mid;
              var newWidth = coords.width + 2 * mid;

              setState(() {
                coords.height = newHeight > 0 ? newHeight : 0;
                coords.width = newWidth > 0 ? newWidth : 0;
                coords.top = coords.top - mid;
                coords.left= coords.left- mid;
              });
            },
            handlerWidget: HandlerWidget.VERTICAL,
          ),
        ),
        //coords.leftcenter
        Positioned(
          top: coords.top + coords.height / 2 - ballDiameter / 2,
          left: coords.left- ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var newWidth = coords.width - dx;

              setState(() {
                coords.width = newWidth > 0 ? newWidth : 0;
                coords.left= coords.left+ dx;
              });
            },
            handlerWidget: HandlerWidget.HORIZONTAL,
          ),
        ),
        // center center
        Positioned(
          top: coords.top + coords.height / 2 - ballDiameter / 2,
          left: coords.left+ coords.width / 2 - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              setState(() {
                coords.top = coords.top + dy;
                coords.left= coords.left+ dx;
              });
            },
            handlerWidget: HandlerWidget.VERTICAL,
          ),
        ),
      ],
    );
  }
}

class ManipulatingBall extends StatefulWidget {
  ManipulatingBall({Key? key, required this.onDrag, required this.handlerWidget});

  final Function onDrag;
  final HandlerWidget handlerWidget;

  @override
  _ManipulatingBallState createState() => _ManipulatingBallState();
}

enum HandlerWidget {HORIZONTAL, VERTICAL}

class _ManipulatingBallState extends State<ManipulatingBall> {
  double? initX;
  double? initY;

  _handleDrag(details) {
    setState(() {
      initX = details.globalPosition.dx;
      initY = details.globalPosition.dy;
    });
  }

  _handleUpdate(details) {
    var dx = details.globalPosition.dx - initX;
    var dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
    widget.onDrag(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handleDrag,
      onPanUpdate: _handleUpdate,
      child: Container(
        width: ballDiameter,
        height: ballDiameter,
        decoration: BoxDecoration(
          color: Colors.pink[700]!,
          shape: this.widget.handlerWidget == HandlerWidget.VERTICAL
              ? BoxShape.circle
              : BoxShape.rectangle,
        ),
      ),
    );
  }
}