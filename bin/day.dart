import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:b/b.dart';
import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scidart/numdart.dart';

import 'advent_of_code.dart';

abstract class Day {
  int get year;

  int get dayNo;

  String? input;

  Future<void> prepareInput();

  Future<void> part_1();
  Future<void> part_2();

  Future<void> run() async {
    await prepareInput();
    part_1();
    part_2();
  }

  late dynamic data;

  Future<String> getInputByDay() => getInput(year, dayNo);

  Future<List<String>> getParsedInput() async {
    String data = await getInputByDay();
    return LineSplitter().convert(data);
  }
}
