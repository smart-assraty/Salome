import 'package:flutter/material.dart';
import 'dart:io' show Process, File, Directory;

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
  late String dayToBackup = "not set";
  late TimeOfDay time = TimeOfDay.now();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: formkey,
          child: Card(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Disk to backup"),
                  controller: diskController,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Must be filled";
                    }
                    RegExp reg = RegExp("^[A-Z]:");
                    if(!value.contains(reg)){
                      return "Usage: {[letter]:}"; 
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Save backup"),
                  controller: backupController,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Must be filled";
                    }
                    RegExp reg = RegExp("^[A-Z]:");
                    if(!value.contains(reg)){
                      return "Usage: {[letter]:}"; 
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Days of week to backup"),
                  controller: dayController,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Must be filled";
                    }
                    RegExp reg = RegExp("^[A-Z]{3}");
                    if(!value.contains(reg)){
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
                  )
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: (){
                    if(formkey.currentState!.validate()){
                      setState(() {
                        diskToBackup = diskController.text;
                        backupToDisk = backupController.text;
                        dayToBackup = dayController.text;
                      });
                      File("${Directory.current.path}\\data\\flutter_assets\\assets\\scripts\\config.ini").writeAsString("wayToFiles=$diskToBackup\nwayToDisk=$backupToDisk\ndisk=${backupToDisk[0]}:\nday=$dayToBackup\nmytime=${time.hour}:${time.minute}\nscript=${Directory.current.path}\\data\\flutter_assets\\assets\\scripts\\Script%231.bat");
                      //File("${Directory.current.path}\\assets\\scripts\\config.ini").writeAsString("wayToFiles=$diskToBackup\nwayToDisk=$backupToDisk\ndisk=${backupToDisk[0]}:\nday=$dayToBackup\nmytime=${time.hour}:${time.minute}\nscript=${Directory.current.path}\\assets\\scripts\\Script#1.bat");
                      File("${Directory.current.path}\\data\\flutter_assets\\assets\\scripts\\Script%231.bat").writeAsString('@rem Script for Nikolai\n@echo off\nfor /f "tokens=1,2 delims==" %%a in (${Directory.current.path}\\data\\flutter_assets\\assets\\scripts\\config.ini) do (\n    if %%a==wayToFiles set wayToFiles=%%b\n    if %%a==wayToDisk set wayToDisk=%%b\n    if %%a==disk set disk=%%b\n)\nstart ${Directory.current.path}\\data\\flutter_assets\\assets\\scripts\\load.exe \\\\.\\%disk%\nxcopy %wayToFiles%\\ %wayToDisk%\nstart ${Directory.current.path}\\data\\flutter_assets\\assets\\scripts\\eject.exe \\\\.\\%disk%');
                      //File("${Directory.current.path}\\assets\\scripts\\Script#1.bat").writeAsString('@rem Script for Nikolai\n@echo off\nfor /f "tokens=1,2 delims==" %%a in (${Directory.current.path}\\assets\\scripts\\config.ini) do (\n    if %%a==wayToFiles set wayToFiles=%%b\n    if %%a==wayToDisk set wayToDisk=%%b\n    if %%a==disk set disk=%%b\n)\nstart ${Directory.current.path}\\assets\\scripts\\load.exe \\\\.\\%disk%\nxcopy %wayToFiles%\\ %wayToDisk%\nstart ${Directory.current.path}\\assets\\scripts\\eject.exe \\\\.\\%disk%');
                      Navigator.pop(context);
                      String out = "blank";
                      Process.run("${Directory.current.path}\\data\\flutter_assets\\assets\\scripts\\Script%231.bat", []).then((value) => out = value.stdout);
                      //Process.run("${Directory.current.path}\\assets\\scripts\\Script#1.bat", []).then((value) => out = value.stdout);
                      showDialog(
                        context: context, 
                        builder: (BuildContext context){
                          return AlertDialog(
                            content: Text(out),
                          );
                        }
                      );
                    }
                  }, 
                  child: const Text("Confirm")
                ),
              ],
            ),
          )
        )
      )
    );
  }
  selectTime(BuildContext context) async {
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context, 
      initialTime: time,
      initialEntryMode: TimePickerEntryMode.dial
    );
    if(timeOfDay != null && timeOfDay != time){
      setState(() {
        time = timeOfDay;
      });
    }
  }
}