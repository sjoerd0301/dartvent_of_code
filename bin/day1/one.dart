import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final file = File('data.txt');

  final lines = file.readAsLinesSync();

  final regex = RegExp('\\d');

  print(lines.map((e) {
    final matches = regex.allMatches(e);
    if (matches.length == 1) {
      return int.parse('${matches.first[0]}${matches.first[0]}');
    }
    return int.parse('${matches.first[0]}${matches.last[0]}');
  }).sum);
}
