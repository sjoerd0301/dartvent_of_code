import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final file = File('data.txt');

  final lines = file.readAsLinesSync();

  print(lines.map((e) => calc(e)).sum);
}

int calc(String game) {
  return game
      .split(': ')[1]
      .split('; ')
      .map((element) => element.split(', ').map(
            (e) {
              final [q, c, ...] = e.split(' ');
              return (c, int.parse(q));
            },
          ).fold({'red': 0, 'green': 0, 'blue': 0}, (previous, element) {
            previous[element.$1] = previous[element.$1]! + element.$2;

            return previous;
          }))
      .fold({'red': 0, 'green': 0, 'blue': 0}, (previousValue, element) {
        if (previousValue['red']! < element['red']!) {
          previousValue['red'] = element['red']!;
        }
        if (previousValue['green']! < element['green']!) {
          previousValue['green'] = element['green']!;
        }
        if (previousValue['blue']! < element['blue']!) {
          previousValue['blue'] = element['blue']!;
        }

        return previousValue;
      })
      .entries
      .fold(
          1,
          (previousValue, element) =>
              previousValue * (element.value == 0 ? 1 : element.value));
}
