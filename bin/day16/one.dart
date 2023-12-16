import 'dart:io';

final visited = <(int, int, Dir)>{};

enum Dir { up, down, left, right }

final energized = <List<String>>[];

void main() {
  final file = File('data.txt');

  final input = file.readAsLinesSync().map((e) => e.split('')).toList();

  for (int y = 0; y < input.length; y++) {
    final tmp = <String>[];
    for (int x = 0; x < input[y].length; x++) {
      tmp.add('.');
    }

    energized.add(tmp);
  }

  calculate(input, (0, 0), Dir.right);

  print(visited.map((e) => (e.$1, e.$2)).toSet().length);
}

void calculate(List<List<String>> data, (int, int) pos, Dir dir) {
  if (visited.contains((pos.$1, pos.$2, dir))) return;

  if ((pos.$1 < 0 && dir == Dir.left) ||
      (pos.$1 == data[0].length && dir == Dir.right)) return;

  if ((pos.$2 < 0 && dir == Dir.up) ||
      (pos.$2 == data.length && dir == Dir.down)) return;

  final tile = data[pos.$2][pos.$1];
  visited.add((pos.$1, pos.$2, dir));
  energized[pos.$2][pos.$1] = '#';
  if ((tile == '\\' && dir == Dir.right) || (tile == '/' && dir == Dir.left)) {
    calculate(data, (pos.$1, pos.$2 + 1), Dir.down);
  } else if ((tile == '\\' && dir == Dir.left) ||
      (tile == '/' && dir == Dir.right)) {
    calculate(data, (pos.$1, pos.$2 - 1), Dir.up);
  } else if ((tile == '\\' && dir == Dir.up) ||
      (tile == '/' && dir == Dir.down)) {
    calculate(data, (pos.$1 - 1, pos.$2), Dir.left);
  } else if ((tile == '\\' && dir == Dir.down) ||
      (tile == '/' && dir == Dir.up)) {
    calculate(data, (pos.$1 + 1, pos.$2), Dir.right);
  } else if (tile == '|' && (dir == Dir.left || dir == Dir.right)) {
    calculate(data, (pos.$1, pos.$2 - 1), Dir.up);
    calculate(data, (pos.$1, pos.$2 + 1), Dir.down);
  } else if (tile == '-' && (dir == Dir.down || dir == Dir.up)) {
    calculate(data, (pos.$1 - 1, pos.$2), Dir.left);
    calculate(data, (pos.$1 + 1, pos.$2), Dir.right);
  } else if (dir == Dir.up) {
    calculate(data, (pos.$1, pos.$2 - 1), Dir.up);
  } else if (dir == Dir.down) {
    calculate(data, (pos.$1, pos.$2 + 1), Dir.down);
  } else if (dir == Dir.left) {
    calculate(data, (pos.$1 - 1, pos.$2), Dir.left);
  } else if (dir == Dir.right) {
    calculate(data, (pos.$1 + 1, pos.$2), Dir.right);
  }
}
