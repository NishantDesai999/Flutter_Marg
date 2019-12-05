import 'package:flutter/material.dart';
import 'pages/page_home.dart';
import'package:flutter/rendering.dart';
import 'db/db_provider.dart';

void main() {
  runApp(MyApp());}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
//    debugPaintLayerBordersEnabled=true;
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData( accentColor: Colors.orange,primaryColor:Colors.blue,iconTheme: IconThemeData(color: Colors.blue),buttonColor: Colors.orange),
        home: HomePage());
  }
}
