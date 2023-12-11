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
        // if (north != null && east != null) {
        //   empty[start.$2][start.$1] = 'L';
        // } else if (north != null && west != null) {
        //   empty[start.$2][start.$1] = 'J';
        // } else if (south != null && west != null) {
        //   empty[start.$2][start.$1] = '7';
        // } else if (south != null && east != null) {
        //   empty[start.$2][start.$1] = 'F';
        // }

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

    empty[position.$2][position.$1] = data[position.$2][position.$1];
  }

  List<String> map = empty.map(
    (e) {
      return e
          .join('')
          .replaceAll(RegExp('F-*7|L-*J'), '')
          .replaceAll(RegExp('F-*J|L-*7'), '|');
    },
  ).toList();

  int ans = 0;

  for (var line in map) {
    int parity = 0;
    for (var c in line.split('')) {
      if (c == '|') parity++;
      if (c == '.' && parity % 2 == 1) ans++;
    }
  }

  print(ans - 1);
}

const matrix = [
  [null, (0, -1), null],
  [(-1, 0), (0, 0), (1, 0)],
  [null, (0, 1), null],
];
