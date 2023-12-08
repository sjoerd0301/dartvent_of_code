import 'dart:io';

import 'package:collection/collection.dart';
import 'dart:math';

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

  for (int y = 0; y < lines.length; y++) {
    for (int x = 0; x < lines[y].length; x++) {
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
        print('x: $x - $end | $number');

        numbers.add(number);

        x = end;
      }
    }
  }

  final regex = RegExp('[^A-Za-z0-9\\.]');

  print(numbers.map((e) {
    int yStart = max(e.y - 1, 0);
    int yEnd = min(e.y + 1, lines.length - 1);

    int xStart = max(e.xStart - 1, 0);
    int xEnd = min(e.xEnd + 1, lines[0].length - 1);

    bool atEnd = xEnd == lines[0].length - 1;

    String substr = '';

    for (int y = yStart; y <= yEnd; y++) {
      substr += atEnd
          ? lines[y].substring(xStart)
          : lines[y].substring(xStart, xEnd + 1);
    }

    return regex.hasMatch(substr) ? e.num : 0;
  }).sum);
}
