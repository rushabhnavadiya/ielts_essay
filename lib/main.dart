import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';

import 'Model/EssayModel.dart';
import 'Screen/HomeScreen.dart';
void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadEssayData().then((value){
      print("Question1 : "+value.question.length.toString());
      print("Answer1 : "+value.answer.length.toString());
      print("essayType1 : "+value.essayType.length.toString());
      print("suggestion1 : "+value.suggestion.length.toString());
    });
    // print(loadEssayData());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}
