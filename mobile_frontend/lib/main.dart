import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MainPage.dart';
import 'canvas/CanvasProvider.dart';

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
      home: const MainPage(title: 'Hand To Print'),
    );
  }
}