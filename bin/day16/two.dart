import 'dart:io';
import 'dart:math';

final visited = <(int, int, Dir)>{};

enum Dir { up, down, left, right }

void main() {
  final file = File('data.txt');

  final input = file.readAsLinesSync().map((e) => e.split('')).toList();

  int maxLen = 0;

  for (int y = 0; y < input.length; y++) {
    maxLen = max(
        calculate(input, (0, y, Dir.right), <(int, int, Dir)>{})
            .map((e) => (e.$1, e.$2))
            .toSet()
            .length,
        maxLen);
    maxLen = max(
        calculate(
                input, (input[0].length - 1, y, Dir.left), <(int, int, Dir)>{})
            .map((e) => (e.$1, e.$2))
            .toSet()
            .length,
        maxLen);
  }

  for (int x = 0; x < input[0].length; x++) {
    maxLen = max(
        calculate(input, (x, 0, Dir.down), <(int, int, Dir)>{})
            .map((e) => (e.$1, e.$2))
            .toSet()
            .length,
        maxLen);
    maxLen = max(
        calculate(input, (x, input.length - 1, Dir.up), <(int, int, Dir)>{})
            .map((e) => (e.$1, e.$2))
            .toSet()
            .length,
        maxLen);
  }

  print(maxLen);
}

Set<(int, int, Dir)> calculate(
    List<List<String>> data, (int, int, Dir) pos, Set<(int, int, Dir)> set) {
  final dir = pos.$3;
  if (set.contains(pos)) return set;

  if ((pos.$1 < 0 && dir == Dir.left) ||
      (pos.$1 == data[0].length && dir == Dir.right)) return set;

  if ((pos.$2 < 0 && dir == Dir.up) ||
      (pos.$2 == data.length && dir == Dir.down)) return set;

  final tile = data[pos.$2][pos.$1];
  set.add(pos);
  if ((tile == '\\' && dir == Dir.right) || (tile == '/' && dir == Dir.left)) {
    return calculate(data, (pos.$1, pos.$2 + 1, Dir.down), set);
  } else if ((tile == '\\' && dir == Dir.left) ||
      (tile == '/' && dir == Dir.right)) {
    return calculate(data, (pos.$1, pos.$2 - 1, Dir.up), set);
  } else if ((tile == '\\' && dir == Dir.up) ||
      (tile == '/' && dir == Dir.down)) {
    return calculate(data, (pos.$1 - 1, pos.$2, Dir.left), set);
  } else if ((tile == '\\' && dir == Dir.down) ||
      (tile == '/' && dir == Dir.up)) {
    return calculate(data, (pos.$1 + 1, pos.$2, Dir.right), set);
  } else if (tile == '|' && (dir == Dir.left || dir == Dir.right)) {
    final tmp = calculate(data, (pos.$1, pos.$2 - 1, Dir.up), set);
    return calculate(data, (pos.$1, pos.$2 + 1, Dir.down), tmp);
  } else if (tile == '-' && (dir == Dir.down || dir == Dir.up)) {
    final tmp = calculate(data, (pos.$1 - 1, pos.$2, Dir.left), set);
    return calculate(data, (pos.$1 + 1, pos.$2, Dir.right), tmp);
  } else if (dir == Dir.up) {
    return calculate(data, (pos.$1, pos.$2 - 1, Dir.up), set);
  } else if (dir == Dir.down) {
    return calculate(data, (pos.$1, pos.$2 + 1, Dir.down), set);
  } else if (dir == Dir.left) {
    return calculate(data, (pos.$1 - 1, pos.$2, Dir.left), set);
  } else if (dir == Dir.right) {
    return calculate(data, (pos.$1 + 1, pos.$2, Dir.right), set);
  }
  return set;
}
