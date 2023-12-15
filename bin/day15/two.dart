import 'dart:io';
import 'package:collection/collection.dart';

void main() {
  final file = File('data.txt');

  final input = file.readAsLinesSync().first.split(',');

  final boxes = <int, Map<String, int>>{};
  final lenses = <String, int>{};

  for (int i = 0; i < 256; i++) {
    boxes[i] = <String, int>{};
  }

  for (final line in input) {
    if (line.contains('-')) {
      final selected = line.substring(0, line.length - 1);

      if (lenses.containsKey(selected)) {
        final boxToManipulate = lenses.remove(selected)!;
        final box = boxes[boxToManipulate]!;
        box.remove(selected)!;
      }
    } else if (line.contains('=')) {
      final splits = line.split('=');

      final int currentBox = splits.first.codeUnits.fold(0,
          (previousValue, element) => ((element + previousValue) * 17) % 256);

      lenses[splits.first] = currentBox;
      boxes[currentBox]![splits.first] = int.parse(splits.last);
    }

    // print('After "$line":');
    // print(boxes.entries
    //     .where((element) => element.value.isNotEmpty)
    //     .toList()
    //     .map((e) =>
    //         'Box ${e.key}: ${e.value.entries.map((b) => '${b.key} ${b.value}').toList().map((e) => '[$e]').join(' ')}')
    //     .join('\n'));
    // print('');
  }

  print(boxes.entries
      .map((b) => b.value.entries
          .mapIndexed((index, l) => (b.key + 1) * (index + 1) * l.value)
          .sum)
      .sum);
}
