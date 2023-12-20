import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final file = File('data.txt');

  final input = file.readAsStringSync();

  final maps = input.split('\n\n');

  final seeds = maps[0].split(': ')[1].split(' ').map((e) => int.parse(e));

  final mapped = maps.skip(1).mapIndexed(
    (index, e) {
      return Map.fromEntries(
        e
            .split('map:\n')[1]
            .split('\n')
            .where((element) => element.isNotEmpty)
            .map(
          (e) {
            final row = e.split(' ').map((e) => int.parse(e)).toList();
            return MapEntry(row[1], (row[0], row[2]));
          },
        ),
      );
    },
  );

  print(seeds.map((e) {
    int currentNumber = e;

    for (final m in mapped) {
      final key = m.keys
          .where((element) => element <= currentNumber)
          .sorted((a, b) => a.compareTo(b));

      if (key.isEmpty) continue;

      final source = key.last;
      final destination = m[key.last]!.$1;
      final range = m[key.last]!.$2;

      final end = source + range;

      if (currentNumber < end) {
        if (source < destination) {
          currentNumber += destination - source;
        } else {
          currentNumber += destination - source;
        }
      }
    }
    return currentNumber;
  }).sorted((a, b) => a.compareTo(b)));
}
