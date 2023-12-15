import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final file = File('data.txt');

  final input = file
      .readAsLinesSync()
      .first
      .split(',')
      .map((e) => e.codeUnits.fold(0,
          (previousValue, element) => ((element + previousValue) * 17) % 256))
      .sum;

  print(input);
}
