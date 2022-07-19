import 'package:flutter/material.dart';
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
                        d = c.getNumberFromLetter(backupToDisk.substring(0, 3));
                      });
                      showDialog(
                        context: context, 
                        builder: (BuildContext context){
                          return AlertDialog(content: Text("[$diskToBackup], [$backupToDisk], [${backupToDisk.substring(0, 3)}], [$dayToBackup], [${d.serialNumber.toString()}]"),);
                        }
                      );
                      checkSerial();
                    }
                    else{
                      showDialog(
                        context: context, 
                        builder: (BuildContext context){
                          return const AlertDialog(content: Text("Fail"),);
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

  void checkSerial(){
    c.getButtons();
    int length = c.getLength();
    for(int i = 0; i < length; ++i){
      if(c.drives[i].serialNumber == d.serialNumber){
        if(c.manageMedia(backupToDisk.substring(0, 2), true)){
          showDialog(
            context: context, 
            builder: (BuildContext context){
              return const AlertDialog(
                content: Text("Success load"),
              );
            }
          );
        }
        else{
          showDialog(
            context: context, 
            builder: (BuildContext context){
              return const AlertDialog(
                content: Text("Fail load"),
              );
            }
          );
        }
        c.copyDir(diskToBackup, backupToDisk);
        if(c.manageMedia(backupToDisk.substring(0, 2), false)){
          showDialog(
            context: context, 
            builder: (BuildContext context){
              return const AlertDialog(
                content: Text("Success eject"),
              );
            }
          );
        }
        else{
          showDialog(
            context: context, 
            builder: (BuildContext context){
              return const AlertDialog(
                content: Text("Fail eject"),
              );
            }
          );
        }
      }
    }
  }
}