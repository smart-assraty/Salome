import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:ffi/ffi.dart' as pffi;
import 'controller.dart' as control;

late control.Drive drive;
bool route = false;

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);
  @override
  State<EventPage> createState() => EventPageState();
}

class EventPageState extends State<EventPage>{
  control.Controller controller = control.Controller();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event"),
      ),
      body: Center(
        child: route ? driveController(drive) : viewController(),
      ),
    );
  }

  Widget viewController(){
    controller.getButtons();
    return TimerBuilder.periodic(
      const Duration(seconds: 1), 
      builder: (context) {
        return Center(
          child: Column(
            children: <Widget>[
              GridView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: controller.drives.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 140.0,
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 5.0
                ),
                itemBuilder: (context, i){
                  return Center(
                    child: ElevatedButton(
                      onPressed: (){
                        setState(() {
                          drive = controller.drives[i];
                          route = true;
                        });
                      }, 
                      child: Text(controller.drives[i].letter.toDartString() + controller.drives[i].serialNumber.toString()),
                    )
                  );
                }
              ),
            ]
          )
        ); 
      },
    );
  }

  Widget driveController(control.Drive button){
    return TimerBuilder.periodic(
      const Duration(seconds: 1), 
      builder: (context) {
        controller.getProcessLog(button);
        return Center(
          child: Text(controller.processLog)
        ); 
      },
    );
  }
}