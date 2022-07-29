import 'package:flutter_html/flutter_html.dart';
import 'dart:io' show File, Directory;
import 'planner.dart' as planner;
import 'event.dart' as event;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    try {
      writeLog('Successfull returning MaterialApp!');
      return MaterialApp(
        builder: (BuildContext context, Widget? widget){
          ErrorWidget.builder = (FlutterErrorDetails errorDetails){
            writeLog(errorDetails.exceptionAsString());
            writeLog(errorDetails.stack.toString());
            return Scaffold(
              appBar: AppBar(
                title: const Text("Error message"),
              ),
              body: Center(
                child: Column(
                  children: [
                    Text(errorDetails.exceptionAsString()),
                    Text(errorDetails.stack.toString()),
                  ],
                ),
              ),
            );
          };
          return widget!;
        },
        title: 'the Salomé Beta v0.1',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'the Salomé Beta v0.1'),
      );
    } on Exception catch (exception) {
      writeLog(exception.toString());
      writeLog('Error in MaterialApp!');
      return ErrorWidget(exception);
    }
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //var file = File("${Directory.current.path}\\assets\\main.html").readAsStringSync();
  var file =
      File("${Directory.current.path}/data/flutter_assets/assets/main.html")
          .readAsStringSync();
  @override
  Widget build(BuildContext context) {
    try {
      writeLog('Successfull opening Widget Scaffold!\n');
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: Drawer(
            child: ListView(children: <Widget>[
          ElevatedButton(
              child: const Text("Event"),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const event.EventPage()))),
          ElevatedButton(
              child: const Text("Planner"),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const planner.PlannerPage())))
        ])),
        body: ListView(
          children: <Widget>[
            Html(data: file),
          ],
        ),
      );
    } on Exception catch (exception) {
      writeLog(exception.toString());
      writeLog('Error in Scaffold!');
      return ErrorWidget(exception);
    }
  }
}

void writeLog(String log) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  String str = ' ';
  await File('${directory.path}\\log.txt')
      .readAsString()
      .then((String contents) {
    str = str + contents;
  });
  final File file1 = File('${directory.path}\\log.txt');
  var sink = file1.openWrite();
  sink.write(str);
  sink.write(log);
}
