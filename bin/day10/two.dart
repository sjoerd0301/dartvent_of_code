import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final file = File('data.txt');

  final input = file.readAsLinesSync();

  final data = input.map((e) => e.split('')).toList();

  final start = data
      .mapIndexed((y, element) => element.mapIndexed((x, element) {
            if (element == 'S') return (x, y);
          }))
      .flattened
      .where((e) => e != null)
      .first!;

  final empty = data.map((e) => e.map((e) => '.').toList()).toList();
  bool finished = false;
  (int, int) position = start;
  (int, int)? previous;

  empty[start.$2][start.$1] = data[start.$2][start.$1];

  int steps = 0;

  final points = <(int, int)>[];

  while (!finished) {
    final projection = matrix
        .map((e) => e.map((e) {
              if (e == null) return null;
              (int, int) pos = (e.$1 + position.$1, e.$2 + position.$2);

              if (previous != null && pos == previous) return null;
              if (pos == position) return null;

              if (pos.$1 < 0 ||
                  pos.$2 < 0 ||
                  pos.$1 == data[0].length ||
                  pos.$2 == data.length) return null;
              if (data[pos.$2][pos.$1] != '.') {
                return data[pos.$2][pos.$1];
              }
            }).toList())
        .toList();

    if (['F', '7', 'J', 'L', 'S'].contains(data[position.$2][position.$1])) {
      points.add(position);
    }

    previous = position;

    final north = projection[0][1];
    final east = projection[1][2];
    final south = projection[2][1];
    final west = projection[1][0];
    final northPos = (position.$1, position.$2 - 1);
    final eastPos = (position.$1 + 1, position.$2);
    final southPos = (position.$1, position.$2 + 1);
    final westPos = (position.$1 - 1, position.$2);

    switch (data[previous.$2][previous.$1]) {
      case 'F':
        // F is a 90-degree bend connecting south and east.

        if ((south == 'S' || east == 'S') && steps != 0) {
          finished = true;
        } else if (south != null) {
          position = southPos;
        } else if (east != null) {
          position = eastPos;
        }
      case '7':
        // 7 is a 90-degree bend connecting south and west.
        if ((south == 'S' || west == 'S') && steps != 0) {
          finished = true;
        } else if (south != null) {
          position = southPos;
        } else if (west != null) {
          position = westPos;
        }
      case 'J':
        // J is a 90-degree bend connecting north and west.
        if ((north == 'S' || west == 'S') && steps != 0) {
          finished = true;
        } else if (north != null) {
          position = northPos;
        } else if (west != null) {
          position = westPos;
        }
      case 'L':
        // L is a 90-degree bend connecting north and east.

        if ((north == 'S' || east == 'S') && steps != 0) {
          finished = true;
        } else if (north != null) {
          position = northPos;
        } else if (east != null) {
          position = eastPos;
        }
      case '-':
        // - is a horizontal pipe connecting east and west.
        if ((east == 'S' || west == 'S') && steps != 0) {
          finished = true;
        } else if (west != null) {
          position = westPos;
        } else if (east != null) {
          position = eastPos;
        }
      case '|':
        // | is a vertical pipe connecting north and south.

        if ((north == 'S' || south == 'S') && steps != 0) {
          finished = true;
        } else if (north != null) {
          position = northPos;
        } else if (south != null) {
          position = southPos;
        }
      case 'S':
        if (north != null) {
          position = northPos;
        } else if (south != null) {
          position = southPos;
        } else if (west != null) {
          position = westPos;
        } else if (east != null) {
          position = eastPos;
        }
    }

    steps++;
  }

  var sum1 = 0;
  var sum2 = 0;

  for (int i = 0; i < points.length; i++) {
    sum1 = sum1 + points[i].$1 * points[(i + 1) % points.length].$2;
    sum2 = sum2 + points[i].$2 * points[(i + 1) % points.length].$1;
  }

  final area = (sum1 - sum2).abs() ~/ 2;

  print(area + 1 - steps ~/ 2);
}

const matrix = [
  [null, (0, -1), null],
  [(-1, 0), (0, 0), (1, 0)],
  [null, (0, 1), null],
];
