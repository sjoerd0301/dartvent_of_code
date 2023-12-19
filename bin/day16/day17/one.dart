import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final file = File('data.txt');

  final input = file
      .readAsLinesSync()
      .map((e) => e.split('').map((e) => int.parse(e)).toList())
      .toList();

  final seen = <(int, int, int, int, int)>{};
  final pq = HeapPriorityQueue<(int, int, int, int, int, int)>(
      (a, b) => a.$1.compareTo(b.$1));

  pq.add((0, 0, 0, 0, 0, 0));

  while (pq.isNotEmpty) {
    final (heatLoss, row, col, dirRow, dirCol, sameN) = pq.removeFirst();

    if (row == input.length - 1 && col == input[0].length - 1) {
      print(heatLoss);
      break;
    }

    if (seen.contains((row, col, dirRow, dirCol, sameN))) {
      continue;
    }

    seen.add((row, col, dirRow, dirCol, sameN));

    if (sameN < 3 && (dirRow != 0 || dirCol != 0)) {
      int newRow = row + dirRow;
      int newCol = col + dirCol;
      if (0 <= newRow &&
          newRow < input.length &&
          0 <= newCol &&
          newCol < input[0].length) {
        pq.add((
          heatLoss + input[newRow][newCol],
          newRow,
          newCol,
          dirRow,
          dirCol,
          sameN + 1
        ));
      }
    }

    for (var direction in [
      [0, 1],
      [1, 0],
      [0, -1],
      [-1, 0],
    ]) {
      int newDirRow = direction[0];
      int newDirCol = direction[1];
      if ((newDirRow != dirRow || newDirCol != dirCol) &&
          (newDirRow != -dirRow || newDirCol != -dirCol)) {
        int newRow = row + newDirRow;
        int newCol = col + newDirCol;
        if (0 <= newRow &&
            newRow < input.length &&
            0 <= newCol &&
            newCol < input[0].length) {
          pq.add((
            heatLoss + input[newRow][newCol],
            newRow,
            newCol,
            newDirRow,
            newDirCol,
            1
          ));
        }
      }
    }
  }
}
