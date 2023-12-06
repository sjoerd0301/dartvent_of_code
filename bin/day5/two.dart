import 'dart:io';
import 'package:compute/compute.dart';

import 'package:collection/collection.dart';

void main() async {
  final file = File('data.txt');

  final input = file.readAsStringSync();

  final maps = input.split('\n\n');

  final seedList =
      maps[0].split(': ')[1].split(' ').map((e) => int.parse(e)).toList();

  final List<(int, int)> seeds = [];

  for (int i = 0; i < seedList.length; i += 2) {
    seeds.add((seedList[i], seedList[i + 1]));
  }

  final start = DateTime.now();

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
            return MapEntry(row[0], <String, int>{'a': row[1], 'b': row[2]});
          },
        ),
      );
    },
  ).toList();

  int? lowest;

  int s = 0, step = 250000;

  while (true) {
    print('computing set ${s / 4}');
    final t = await Future.wait([1, 2, 3, 4].map((e) {
      return compute(backwards, <String, dynamic>{
        'mapped': mapped,
        'element': Map.fromEntries(seeds.map((e) => MapEntry(e.$1, e.$2))),
        'start': (s++ * step) + 1,
        'end': (s * step) + 1
      });
    }));

    if (t.any((element) => element != null)) {
      print(t.where((element) => element != null));
      break;
    }
  }

  final end = DateTime.now();

  print('Running took: ${end.difference(start)}');
}

int? backwards(Map<String, dynamic> data) {
  final mapped = data['mapped'] as List<Map<int, Map<String, int>>>;
  final seedMap = data['element'] as Map<int, int>;
  int start_val = data['start'] as int;
  int end_val = data['end'] as int;

  final seeds = seedMap.entries.map((e) => (e.key, e.value));

  for (int e = start_val; e <= end_val; e++) {
    int currentNumber = e;
    for (final m in mapped.reversed) {
      final key = m.keys
          .where((element) => element <= currentNumber)
          .sorted((a, b) => a.compareTo(b));

      if (key.isEmpty) {
        continue;
      }

      final source = key.last;
      final destination = m[key.last]!['a']!;
      final range = m[key.last]!['b']!;

      final end = source + range;

      if (currentNumber < end) {
        currentNumber += destination - source;
      }
    }

    final seed = seeds.where((element) =>
        element.$1 <= currentNumber &&
        currentNumber <= (element.$1 + element.$2));

    if (seed.isNotEmpty) {
      return e;
    }
  }

  return null;
}
