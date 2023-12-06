import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final file = File('data.txt');

  final lines = file.readAsLinesSync();

  final wsRegex = RegExp('\\s+');

  var winnings = lines.map((e) {
    final card = e.split(': ')[1].split('| ');
    final winning =
        card[0].trim().split(wsRegex).map((e1) => int.parse(e1.trim())).toSet();
    final mine =
        card[1].trim().split(wsRegex).map((e1) => int.parse(e1.trim())).toSet();

    return mine.intersection(winning).length;
  });

  Map<int, int> cards = Map.fromEntries(
      winnings.indexed.mapIndexed((index, element) => MapEntry(index + 1, 1)));

  for (int i = 0; i < winnings.length; i++) {
    for (int j = 0; j < cards.values.elementAt(i); j++) {
      for (int k = 0; k < winnings.elementAt(i); k++) {
        cards[k + i + 2] = cards[k + i + 2]! + 1;
      }
    }
  }

  print(cards.values.sum);
}
