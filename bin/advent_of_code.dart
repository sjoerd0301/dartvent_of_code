import 'dart:io';
import 'dart:math';
import 'dart:mirrors' as m;

import 'package:http/http.dart' as http;
import 'package:dotenv/dotenv.dart' show load, env;

//ignore: unused_import
import 'day.dart'; //needed for reflection

late final String cookie;

Future<String> getInput(int year, int day) async {
  Uri url = Uri.parse('https://adventofcode.com/$year/day/$day/input');

  final resp = await http.get(url, headers: {'cookie': cookie});

  return resp.body;
}

void main(List<String> arguments) async {
  load();
  cookie = env['COOKIE'] as String;

  Map<int, Map<int, m.ObjectMirror>> yearList = {2021: {}, 2022: {}};

  final ms = m.currentMirrorSystem();

  ms.libraries.forEach((key, value) {
    if (value.simpleName == Symbol('days')) {
      value.declarations.forEach((key, value) {
        if (value is m.ClassMirror &&
            ((value.superclass?.hasReflectedType ?? false) &&
                value.superclass?.simpleName == Symbol('Day'))) {
          m.ObjectMirror obj = value.newInstance(Symbol(''), []);

          yearList[obj.getField(Symbol('dayNo')).reflectee as int]![
              obj.getField(Symbol('year')).reflectee as int] = obj;
        }
      });
    }
  });

  final selection = DateTime.now().year;

  stdout.write(
      'Select year (${yearList.keys.join(', ')}) (press enter to select $selection): ');
  String? input = stdin.readLineSync();
  if (input?.isNotEmpty ?? false) {
    int? selection = int.tryParse(input!);
  }

  final classList = yearList[selection]!;

  while (true) {
    stdout.write(
        'select which day you want to run(${classList.keys.reduce(min)}-${classList.keys.reduce(max)}) or q to quit: ');

    String? input = stdin.readLineSync();

    if (input == null) {
      stdout.writeln("Please input a valid selection...");
    } else {
      if (input == 'q') {
        break;
      } else {
        int? selection = int.tryParse(input);
        if (selection == null || !classList.keys.contains(selection)) {
          stdout.writeln("Please input a valid selection...");
        } else {
          int parts = classList[selection]!.getField(Symbol('parts')).reflectee;
          int partno = 1;
          if (parts > 1) {
            while (true) {
              stdout.write(
                  'select which part you want to run(1-$parts) or b to go back: ');

              String? input = stdin.readLineSync();

              if (input == null) {
                stdout.writeln("Please input a valid selection...");
              } else {
                if (input == 'b') {
                  break;
                } else {
                  int? partSelection = int.tryParse(input);
                  if (partSelection == null ||
                      partSelection < 1 ||
                      partSelection > parts) {
                    stdout.writeln("Please input a valid selection...");
                  } else {
                    await classList[selection]!
                        .invoke(Symbol('run'), [partSelection]).reflectee;
                    break;
                  }
                }
              }
            }
          } else {
            await classList[selection]!
                .invoke(Symbol('run'), [partno]).reflectee;
          }
        }
      }
    }
  }
}
