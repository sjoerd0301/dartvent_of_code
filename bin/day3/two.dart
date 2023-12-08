import 'dart:io';

import 'package:collection/collection.dart';

const String symbols = '!@#\$%^&*()_+\\/><,|~`\'";:';
const String digits = '1234567890';

class Number {
  final int xStart, y, num;

  Number(this.xStart, this.y, this.num);

  int get xEnd =>
      xStart +
      (num > 999
          ? 4
          : num > 99
              ? 3
              : num > 9
                  ? 2
                  : 1) -
      1;

  @override
  String toString() => '$num: $xStart - $xEnd, $y';
}

void main() {
  final file = File('data.txt');

  final lines = file.readAsLinesSync();

  List<Number> numbers = [];

  List<(int x, int y)> possibleGears = [];

  for (int y = 0; y < lines.length; y++) {
    for (int x = 0; x < lines[y].length; x++) {
      if (lines[y][x] == '*') {
        possibleGears.add((x, y));
      }

      if (digits.contains(lines[y][x])) {
        //contains number, get end
        int end = 0;
        for (int w = x; w < lines[y].length; w++) {
          end = w;
          if (!digits.contains(lines[y][w])) {
            end = w - 1;
            break;
          }
        }

        String numStr = end == lines[y].length - 1
            ? lines[y].substring(x)
            : lines[y].substring(x, end + 1);

        final number = Number(x, y, int.parse(numStr));

        numbers.add(number);

        x = end;
      }
    }
  }

  print(possibleGears.map((e) {
    Set<Number> nums = {};

    for (final element in numbers) {
      final yStart = e.$2 - 1;
      final yEnd = e.$2 + 1;

      final xStart = e.$1 - 1;
      final xEnd = e.$1 + 1;

      if (yStart <= element.y &&
          element.y <= yEnd &&
          xStart <= element.xEnd &&
          element.xStart <= xEnd) {
        nums.add(element);
      }
    }

    if (nums.isNotEmpty && nums.length == 2) {
      return nums.first.num * nums.last.num;
    }

    return 0;
  }).sum);
}
