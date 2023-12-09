import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final file = File('data.txt');

  final input = file.readAsLinesSync();

  print(input.map((e) => e.split(' ').map((e) => int.parse(e))).map(
    (l) {
      final output = <List<int>>[l.toList().reversed.toList()];
      while (!output.last.every((element) => element == 0)) {
        final tmp = <int>[];
        for (int i = 0; i < output.last.length - 1; i++) {
          tmp.add(output.last[i + 1] - output.last[i]);
        }

        output.add(tmp);
      }

      for (int i = output.length - 2; i >= 0; i--) {
        output[i].add(output[i + 1].last + output[i].last);
      }

      return output.first.last;
    },
  ).sum);
}
