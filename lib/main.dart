import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:io' show File, Directory;
import 'planner.dart' as planner;
import 'event.dart' as event;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'the Salomé Beta v0.1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'the Salomé Beta v0.1'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  //var file = File("${Directory.current.path}\\assets\\main.html").readAsStringSync();
  var file = File("${Directory.current.path}\\data\\flutter_assets\\assets\\main.html").readAsStringSync();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ElevatedButton(
              child: const Text("Event"),
              onPressed: () => Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (BuildContext context) => const event.EventPage()
                )
              )
            ),
            ElevatedButton(
              child: const Text("Planner"),
              onPressed: () => Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (BuildContext context) => const planner.PlannerPage()
                )
              )
            )
          ]
        )
      ),
      body: ListView(
        children: <Widget>[
          Html(data: file),
        ],
      ), 
    );
  }
}