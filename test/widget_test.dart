import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterfiles/planner.dart';
import 'package:flutterfiles/event.dart';
import 'package:flutterfiles/main.dart';
import 'package:flutterfiles/controller.dart';
import 'dart:io';
import 'package:ffi/ffi.dart' as pffi;

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpWidget(const MaterialApp(home: EventPage()));
    await tester.pumpWidget(const MaterialApp(home: PlannerPage()));
  });

  group("Main", (){
    test("File shall be read", (){
      var file = File("C:\\Users\\user2\\FlutterProject\\lib\\main.html").readAsStringSync();
      expect(file.isNotEmpty, true);
    });
  });

  group("Controller", (){
    test("The 'notepad.exe' Process shall be found", (){
      expect(Controller().findProc(), false);
    });

    test("Number shall be given", (){
      expect(Controller().getLength(), 6);
    });

    test("A Drive shall be given", (){
      Drive d;
      d = Controller().getNumber(0);
      expect(d.letter.toDartString(), "C:\\");
      //expect(d.serialNumber, 3624586914);
      d = Controller().getNumber(4);
      expect(d.letter.toDartString(), "D:\\");
      //expect(d.serialNumber, 101526456);
      d = Controller().getNumber(8);
      expect(d.letter.toDartString(), "E:\\");
      //expect(d.serialNumber, 2115155209);
      d = Controller().getNumber(12);
      expect(d.letter.toDartString(), "F:\\");
      //expect(d.serialNumber, 35615289);
      d = Controller().getNumber(16);
      expect(d.letter.toDartString(), "G:\\");
      //expect(d.serialNumber, 1080741720);
      d = Controller().getNumber(20);
      expect(d.letter.toDartString(), "H:\\");
      //expect(d.serialNumber, 1080741720);
    });

    test("'drives' shall be filled", (){
      Controller c = Controller();
      c.getButtons();
      expect(c.drives.isNotEmpty, true);
    });

    test("Process shall be logged and drive shall be removed on Process kill", (){
      Controller c = Controller();
      Drive d = c.getNumber(0);
      c.getProcessLog(d);
    });
  });
}

