import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show Process, File, Directory;
import 'controller.dart' as control;

class PlannerPage extends StatefulWidget {
  const PlannerPage({Key? key}) : super(key: key);
  final String title = "Planner";

  @override
  State<PlannerPage> createState() => PlannerPageState();
}

class PlannerPageState extends State<PlannerPage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController diskController = TextEditingController();
  TextEditingController backupController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  late String diskToBackup = "not set";
  late String backupToDisk = "not set";
  late control.Drive d;
  late String dayToBackup = "not set";
  late TimeOfDay time = TimeOfDay.now();
  control.Controller c = control.Controller();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Form(
                key: formkey,
                child: Card(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration:
                            const InputDecoration(hintText: "Disk to backup"),
                        controller: diskController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Must be filled";
                          }
                          RegExp reg = RegExp("^[A-Z]:.");
                          if (!value.contains(reg)) {
                            return "Usage: {[letter]:\\}";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(hintText: "Save backup"),
                        controller: backupController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Must be filled";
                          }
                          RegExp reg = RegExp("^[A-Z]:.");
                          if (!value.contains(reg)) {
                            return "Usage: {[letter]:\\}";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            hintText: "Days of week to backup"),
                        controller: dayController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Must be filled";
                          }
                          RegExp reg = RegExp("^[A-Z]{3}");
                          if (!value.contains(reg)) {
                            return "Usage: {MON, TUE, WED, THU, FRI, SAT, SUN}";
                          }
                          return null;
                        },
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: ElevatedButton(
                            onPressed: () {
                              selectTime(context);
                            },
                            child: const Text("Set time"),
                          )),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          final Directory directory =
                              await getApplicationDocumentsDirectory();
                          String str = '';
                          await File('${directory.path}\\log.txt')
                              .readAsString()
                              .then((String contents) {
                            str = str + contents;
                          });
                          final File file = File('${directory.path}\\log.txt');
                          var sink = file.openWrite();
                          sink.write(str);
                          if (formkey.currentState!.validate()) {
                            setState(() {
                              diskToBackup = diskController.text;
                              backupToDisk = backupController.text;
                              dayToBackup = dayController.text;
                              d = c.getNumberFromLetter(
                                  backupToDisk.substring(0, 3));
                            });
                            DateTime now = DateTime.now();
                            sink.write('Date: $now\n');
                            sink.write(
                                'Info: [$diskToBackup], [$backupToDisk], [${backupToDisk.substring(0, 3)}], [$dayToBackup], [${d.serialNumber.toString()}]\n');
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Text(
                                        "[$diskToBackup], [$backupToDisk], [${backupToDisk.substring(0, 3)}], [$dayToBackup], [${d.serialNumber.toString()}]"),
                                  );
                                });
                            sink.write('Checking Serial Number!\n');
                            int a = checkSerial(sink);
                            if (a == 1) {
                              var result = await Process.run(
                                  'assets/scripts/Tasksch.bat', [],
                                  runInShell: true);
                              sink.write('Added to Task Schedule\n');
                            }
                            sink.write('\n\n');
                          } else {
                            sink.write('Process failed!\n\n\n');
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const AlertDialog(
                                    content: Text("Fail"),
                                  );
                                });
                          }
                        },
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
                ))));
  }

  selectTime(BuildContext context) async {
    TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: time,
        initialEntryMode: TimePickerEntryMode.dial);
    if (timeOfDay != null && timeOfDay != time) {
      setState(() {
        time = timeOfDay;
      });
    }
  }

  int checkSerial(var sink) {
    c.getButtons();
    int length = c.getLength();
    for (int i = 0; i < length; ++i) {
      if (c.drives[i].serialNumber == d.serialNumber) {
        if (c.manageMedia(backupToDisk.substring(0, 2), true)) {
          sink.write('Success Load!\n');
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  content: Text("Success load"),
                );
              });
          //c.copyDir(diskToBackup, backupToDisk);
          if (c.manageMedia(backupToDisk.substring(0, 2), false)) {
            sink.write('Success eject!\n');
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AlertDialog(
                    content: Text("Success eject"),
                  );
                });
            return 1;
          } else {
            sink.write('Fail eject!\n');
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AlertDialog(
                    content: Text("Fail eject"),
                  );
                });
            return 0;
          }
        } else {
          sink.write('Fail Load!\n');
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  content: Text("Fail load"),
                );
              });
          return 0;
        }
      }
    }
    return 0;
  }

  void writeFiles() {
    File('data\\flutter_assets\\assets\\scripts\\config.ini').writeAsStringSync(
        'way=$diskToBackup\ndisk=$diskToBackup\nmytime=${time.hour}:${time.minute}\nscript=${Directory.current.path}\\data\\flutter_assets\\assets\\scripts\\Tasksch.bat');
    File('data\\flutter_assets\\assets\\scripts\\Backup.bat').writeAsStringSync(
        '@rem Event\n@echo off\nchcp 850\nfor /f "tokens=1,2 delims==" %%a in (${Directory.current.path}\\data\\flutter_assets\\assets\\scripts\\config.ini) do (\n    if %%a==mytime set mytime=%%b\n    if %%a==day set day=%%b\n)\nschtasks /create /sc weekly /d %day% /tn hardtime /sd %date:~-10% /st %mytime% /tr ${Directory.current.path}\\data\\flutter_assets\\assets\\scripts\\Backup.bat');
    File('data\\flutter_assets\\assets\\scripts\\Backup.bat').writeAsStringSync(
        'start \\b ${Directory.current.path}\\data\\flutter_assets\\assets\\scripts\\load.exe \\\\.\\${backupToDisk.substring(0, 2)}\nset mydate=%DATE:~3,2%-%DATE:~0,2%-%DATE:~6,4%\nxcopy /y /o /e /d:%mydate% "$diskToBackup" "$backupToDisk"\nstart \\b ${Directory.current.path}\\data\\flutter_assets\\assets\\scripts\\eject.exe \\\\.\\${backupToDisk.substring(0, 2)}');
    /*File('assets\\scripts\\config.ini').writeAsStringSync('way=$diskToBackup\ndisk=$backupToDisk\nday=$dayToBackup\nmytime=${time.hour}:${time.minute}\n');
    File('assets\\scripts\\Tasksch.bat').writeAsStringSync('@rem Event\n@echo off\nchcp 850\nfor /f "tokens=1,2 delims==" %%a in (${Directory.current.path}\\assets\\scripts\\config.ini) do (\n    if %%a==mytime set mytime=%%b\n    if %%a==day set day=%%b\n)\nschtasks /create /sc weekly /d %day% /tn hardtime /sd %date:~-10% /st %mytime% /tr ${Directory.current.path}\\assets\\scripts\\Backup.bat');
    File('assets\\scripts\\Backup.bat').writeAsStringSync('start \\b ${Directory.current.path}\\assets\\scripts\\load.exe \\\\.\\${backupToDisk.substring(0, 2)}\nset mydate=%DATE:~3,2%-%DATE:~0,2%-%DATE:~6,4%\nxcopy /y /o /e /d:%mydate% "$diskToBackup" "$backupToDisk"\nstart \\b ${Directory.current.path}\\assets\\scripts\\eject.exe \\\\.\\${backupToDisk.substring(0, 2)}');*/
  }
}
