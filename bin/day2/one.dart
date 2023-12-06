import 'dart:io';

import 'package:collection/collection.dart';

const bag = {'red': 12, 'green': 13, 'blue': 14};

void main() {
  final file = File('data.txt');

  final lines = file.readAsLinesSync();

  int total = 0;

  print(lines.indexed.map((pair) => isValid(pair.$2) ? pair.$1 + 1 : 0).sum);
}

bool isValid(String game) {
  return game.split(': ')[1].split('; ').every(
        (element) => element.split(', ').map(
          (e) {
            final [q, c, ...] = e.split(' ');
            return (int.parse(q), c);
          },
        ).every(
          (element) => element.$1 <= bag[element.$2]!,
        ),
      );
}
