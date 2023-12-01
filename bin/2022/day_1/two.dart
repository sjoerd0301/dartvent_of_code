import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

void main() {
  String lines = File('${Directory.current.path}/input').readAsStringSync();

  int output = lines
      .split('\n\n')
      .map((e) => e.split('\n').map((e) => int.parse(e)).sum)
      .stdout('Max: $output');
}
