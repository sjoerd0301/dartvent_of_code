import 'dart:io';
import 'package:collection/collection.dart';

void main() {
  final file = File('data.txt');

  final input = file.readAsLinesSync().first.split(',');

  final boxes = <int, Map<String, int>>{};

  for (int i = 0; i < 256; i++) {
    boxes[i] = <String, int>{};
  }

  for (final line in input) {
    if (line.contains('-')) {
      final label = line.substring(0, line.length - 1);
      final hashed = hash(label);

      final box = boxes[hashed]!;
      if (box.containsKey(label)) {
        box.remove(label)!;
      }
    } else {
      final splits = line.split('=');

      final int currentBox = hash(splits.first);

      boxes[currentBox]![splits.first] = int.parse(splits.last);
    }
  }

  print(boxes.entries
      .map((b) => b.value.entries
          .mapIndexed((index, l) => (b.key + 1) * (index + 1) * l.value)
          .sum)
      .sum);
}

int hash(String data) => data.codeUnits.fold(
    0, (previousValue, element) => ((element + previousValue) * 17) % 256);
