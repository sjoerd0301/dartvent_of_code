import 'dart:io';
import 'dart:math';

void main() {
  final file = File('data.txt');

  final input = file.readAsLinesSync().map((e) => e.split('').toList()).toList();

  final start = (0, input.first.indexOf('.'));
  final end = (input.length - 1, input.last.indexOf('.'));

  List<(int, int)> points = [start, end];

  for (int r = 0; r < input.length; r++) {
    for (int c = 0; c < input[r].length; c++) {
      if (input[r][c] == '#') {
        continue;
      }

      int neighbors = 0;
      for ((int, int) offset in [(-1, 0), (1, 0), (0, -1), (0, 1)]) {
        int nr = r + offset.$1;
        int nc = c + offset.$2;
        if (0 <= nr &&
            nr < input.length &&
            0 <= nc &&
            nc < input[0].length &&
            input[nr][nc] != '#') {
          neighbors += 1;
        }
      }
      if (neighbors >= 3) {
        points.add((r, c));
      }
    }
  }

  Map<String, List<(int, int)>> dirs = {
    '^': [(-1, 0)],
    'v': [(1, 0)],
    '<': [(0, -1)],
    '>': [(0, 1)],
    '.': [(-1, 0), (1, 0), (0, -1), (0, 1)],
  };

  for ((int, int) point in points) {
    int sr = point.$1;
    int sc = point.$2;
    List<(int, int, int)> stack = [(0, sr, sc)];
    Set<(int, int)> seen = {(sr, sc)};

    while (stack.isNotEmpty) {
      final (n, r, c) = stack.removeLast();

      if (n != 0 && points.contains((r, c))) {
        graph.putIfAbsent((sr, sc), () => {});
        graph[(sr, sc)]![(r, c)] = n;
        continue;
      }

      for ((int, int) offset in dirs[input[r][c]]!) {
        int dr = offset.$1;
        int dc = offset.$2;
        int nr = r + dr;
        int nc = c + dc;

        if (0 <= nr &&
            nr < input.length &&
            0 <= nc &&
            nc < input[0].length &&
            input[nr][nc] != '#' &&
            !seen.contains((nr, nc))) {
          stack.add((n + 1, nr, nc));
          seen.add((nr, nc));
        }
      }
    }
  }

  print(dfs(start, end));
}

Map<(int, int), Map<(int, int), int>> graph = {};
Set<(int, int)> seen = {};

int dfs((int, int) pt, (int, int) end) {
  if (pt == end) {
    return 0;
  }

  int m = -9999999;

  seen.add(pt);
  for ((int, int) nx in graph[pt]!.keys) {
    if (!seen.contains(nx)) {
      m = max(m, dfs(nx, end) + graph[pt]![nx]!);
    }
  }
  seen.remove(pt);

  return m;
}
