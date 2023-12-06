import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final file = File('data.txt');

  final lines = file.readAsLinesSync();

  final wsRegex = RegExp('\\s+');

  print(lines.map((e) {
    final card = e.split(': ')[1].split('| ');
    final winning =
        card[0].trim().split(wsRegex).map((e1) => int.parse(e1.trim())).toSet();
    final mine =
        card[1].trim().split(wsRegex).map((e1) => int.parse(e1.trim())).toSet();

    return mine.intersection(winning).fold(0,
        (previousValue, element) => previousValue == 0 ? 1 : previousValue * 2);
  }).sum);
}
