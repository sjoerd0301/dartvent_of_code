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

  final size = input.length;
  final half = size ~/ 2;

  int steps = 26501365;

  var x = <int>[];

  if (steps % 2 == 0) {
    x = [half + (2 * size), half + (4 * size), half + (6 * size)];
  } else {
    x = [half + (1 * size), half + (3 * size), half + (5 * size)];
  }

  final y = x
      .map((e) => calc(start, input,
          List<List<String>>.from(input.map((e) => List<String>.from(e))), e))
      .toList();

  print(lagrangeInterpolation(x, y, steps).toInt());
}

double lagrangeInterpolation(List<int> xValues, List<int> yValues, int x) {
  double result = 0;

  for (int i = 0; i < xValues.length; i++) {
    double term = yValues[i].toDouble();
    for (int j = 0; j < xValues.length; j++) {
      if (j != i) {
        term *= (x - xValues[j]) / (xValues[i] - xValues[j]);
      }
    }
    result += term;
  }

  return result;
}

bool isValid(List<List<String>> data, (int, int) pos, Set<(int, int)> visited) {
  if (data[pos.$2 % (data.length)][pos.$1 % (data[0].length)] == '#') {
    return false;
  }

  if (visited.contains(pos)) return false;

  return true;
}

int calc((int, int) start, List<List<String>> input, List<List<String>> empty,
    int totalSteps) {
  final visited = <(int, int)>{start};
  final end = <(int, int)>{};

  final toVisit = <(int, int)>[start];

  int steps = 0;

  while (steps <= totalSteps) {
    final t = <(int, int)>[];
    for (final pos in toVisit) {
      if (steps % 2 == 0) {
        end.add(pos);
      }

      for (final nextpos in [
        (0, -1),
        (1, 0),
        (0, 1),
        (-1, 0),
      ]) {
        final n = ((pos.$1 + nextpos.$1), (pos.$2 + nextpos.$2));
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

  return end.length;
}
