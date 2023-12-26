import 'dart:collection';
import 'dart:io';
import 'dart:math';

void main() {
  final file = File('data.txt');

  final input = file.readAsLinesSync().map((e) {
    final splits = e.split('~');
    final start = splits.first.split(',').map((e) => int.parse(e)).toList();
    final end = splits.last.split(',').map((e) => int.parse(e)).toList();

    return ((start[0], start[1], start[2]), (end[0], end[1], end[2]));
  }).toList();

  //sort by Z
  input.sort((a, b) => a.$1.$3.compareTo(b.$1.$3));

  //final settled = <((int, int, int), (int, int, int))>[];

  for (int i = 0; i < input.length; i++) {
    int zMax = 1;
    var brick = input[i];
    for (final check in input.sublist(0, i)) {
      if (collide(check, brick)) {
        zMax = max(zMax, check.$2.$3 + 1);
      }
    }

    var ((minX, minY, minZ), (maxX, maxY, maxZ)) = brick;

    input[i] = (
      (minX, minY, zMax),
      (maxX, maxY, maxZ - (minZ - zMax)),
    );
  }

  //sort by Z
  input.sort((a, b) => a.$1.$3.compareTo(b.$1.$3));

  final upperLower = <int, Set<int>>{
    for (int i = 0; i < input.length; i++) i: {}
  };
  final lowerUpper = <int, Set<int>>{
    for (int i = 0; i < input.length; i++) i: {}
  };

  for (int i = 0; i < input.length; i++) {
    final upper = input[i];
    for (int j = 0; j < i; j++) {
      final lower = input[j];
      if (collide(upper, lower) && upper.$1.$3 == lower.$2.$3 + 1) {
        upperLower[i]!.add(j);
        lowerUpper[j]!.add(i);
      }
    }
  }

  int total = 0;

  for (int i = 0; i < input.length; i++) {
    Queue<int> q =
        Queue.from(lowerUpper[i]!.where((j) => upperLower[j]!.length == 1));
    Set<int> falling = {...q, i};

    while (q.isNotEmpty) {
      int j = q.removeFirst();
      for (int k in lowerUpper[j]!.difference(falling)) {
        if (upperLower[k]!.every((v) => falling.contains(v))) {
          q.add(k);
          falling.add(k);
        }
      }
    }

    total += falling.length - 1;
  }

  print(total);
}

bool collide(
    (
      (int, int, int),
      (int, int, int),
    ) a,
    (
      (int, int, int),
      (int, int, int),
    ) b) {
  // ignore: unused_local_variable
  final ((aMinX, aMinY, aMinZ), (aMaxX, aMaxY, aMaxZ)) = a;
  // ignore: unused_local_variable
  final ((bMinX, bMinY, bMinZ), (bMaxX, bMaxY, bMaxZ)) = b;

  final xO = aMaxX >= bMinX && aMinX <= bMaxX;
  final yO = aMaxY >= bMinY && aMinY <= bMaxY;

  return xO && yO; //&& zO;
}
