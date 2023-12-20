import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final file = File('data.txt');

  final dirs = {"U": (-1, 0), "D": (1, 0), "L": (0, -1), "R": (0, 1)};
  int count = 0;
  final points = [(0, 0)];

  final input = file
      .readAsLinesSync()
      .map((e) => e.split(' ').sublist(0, 2).mapIndexed(
          (index, element) => index == 1 ? int.parse(element) : element))
      .map((e) => (e.first as String, e.last as int))
      .toList();

  for (int i = 0; i < input.length; i++) {
    final (d, c) = input[i];
    final dir = dirs[d];
    count += c;

    final lastPoint = points.last;
    points.add((lastPoint.$1 + dir!.$1 * c, lastPoint.$2 + dir.$2 * c));
  }

  points.removeAt(0);

  int A = 0;
  for (int i = 0; i < points.length; i++) {
    final prev = points[(i - 1) % points.length];
    final cur = points[i];
    final next = points[(i + 1) % points.length];

    A += cur.$1 * (prev.$2 - next.$2);
  }
  A = A.abs() ~/ 2;

  int i = A - count ~/ 2 + 1;

  print(i + count);
}
