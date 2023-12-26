import 'dart:io';

import 'package:collection/collection.dart';

final tmp = <List<String>>[];

void main() {
  final file = File('data.txt');

  final input =
      file.readAsLinesSync().map((e) => e.split('').toList()).toList();

  final start = input.foldIndexed(
      <(int, int)?>[],
      (y, p, e) => [
            ...p,
            ...e.mapIndexed((x, e) => e == 'S' ? (x, y) : null)
          ]).firstWhere((e) => e != null)!;

  for (int y = 0; y < input.length; y++) {
    final t = <String>[];

    for (int x = 0; x < input[0].length; x++) {
      t.add(input[y][x]);
    }

    tmp.add(t);
  }

  final visited = <(int, int)>{start};
  final end = <(int, int)>{};

  final toVisit = <(int, int)>[start];

  int steps = 0, totalSteps = 66;

  while (steps <= totalSteps) {
    final t = <(int, int)>[];
    for (final next in toVisit) {
      if (steps % 2 == 0) {
        end.add(next);
      }

      for (final nextpos in [
        (0, -1),
        (1, 0),
        (0, 1),
        (-1, 0),
      ]) {
        final n = (next.$1 + nextpos.$1, next.$2 + nextpos.$2);
        if (!isValid(input, n, visited)) {
          continue;
        }

        t.add(n);
        visited.add(n);
      }
    }

    toVisit.clear();
    toVisit.addAll(t);
    steps++;
  }

  print(end.length);

  print(tmp
      .mapIndexed((y, e) => e
          .mapIndexed((x, e) => input[y][x].contains('S')
              ? 'S'
              : end.contains((x, y))
                  ? 'O'
                  : input[y][x])
          .join(''))
      .join('\n'));
}

bool isValid(List<List<String>> data, (int, int) pos, Set<(int, int)> visited) {
  if (pos.$1 == data[0].length || pos.$1 < 0) return false;
  if (pos.$2 == data.length || pos.$2 < 0) return false;
  if (data[pos.$2][pos.$1] == '#') return false;
  if (visited.contains(pos)) return false;

  return true;
}
