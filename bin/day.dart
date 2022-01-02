library days;

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:b/b.dart';
import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scidart/numdart.dart';

import 'advent_of_code.dart';

part 'day_1.dart';
part 'day_2.dart';
part 'day_3.dart';
part 'day_4.dart';
part 'day_5.dart';
part 'day_6.dart';
part 'day_7.dart';
part 'day_8.dart';
part 'day_9.dart';
part 'day_10.dart';
part 'day_11.dart';

part 'day_15.dart';

abstract class Day {
  int get dayNo;
  int get parts => 2;

  String? input;

  Future<void> prepareInput();

  Future<void> part_1();
  Future<void> part_2();

  Future<void> run(int part) async {
    await prepareInput();
    if (part == 1) {
      part_1();
    } else {
      part_2();
    }
  }

  late dynamic data;

  Future<String> getInputByDay() => getInput(dayNo);

  Future<List<String>> getParsedInput() async {
    String data = await getInputByDay();
    return LineSplitter().convert(data);
  }
}
