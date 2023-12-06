import 'dart:io';

import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:math';

const String symbols = '!@#\$%^&*()_+\\/><,|~`\'";:';
const String digits = '1234567890';

class Number {
  final int x_start, y, num;

  Number(this.x_start, this.y, this.num);

  int get x_end =>
      x_start +
      (num > 999
          ? 4
          : num > 99
              ? 3
              : num > 9
                  ? 2
                  : 1) -
      1;

  @override
  String toString() => '$num: $x_start - $x_end, $y';
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

        String num_str = end == lines[y].length - 1
            ? lines[y].substring(x)
            : lines[y].substring(x, end + 1);

        final number = Number(x, y, int.parse(num_str));

        numbers.add(number);

        x = end;
      }
    }
  }

  print(possibleGears.map((e) {
    Set<Number> nums = {};

    numbers.forEach((element) {
      final y_start = e.$2 - 1;
      final y_end = e.$2 + 1;

      final x_start = e.$1 - 1;
      final x_end = e.$1 + 1;

      if (y_start <= element.y &&
          element.y <= y_end &&
          x_start <= element.x_end &&
          element.x_start <= x_end) {
        nums.add(element);
      }
    });

    if (nums.isNotEmpty && nums.length == 2) {
      return nums.first.num * nums.last.num;
    }

    return 0;
  }).sum);
}
