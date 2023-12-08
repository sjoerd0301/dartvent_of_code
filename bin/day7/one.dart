import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final file = File('data.txt');

  final input = file.readAsLinesSync();

  List<(String, int)> fivek = [],
      fourk = [],
      fullh = [],
      threek = [],
      twop = [],
      onep = [],
      high = [];

  final hands = input.map((e) {
    final split = e.split(' ');
    return (split[0], int.parse(split[1]));
  });

  hands.forEach((hand) {
    final set = hand.$1.split('').toSet();
    if (set.length == 5) {
      high.add(hand);
      return;
    }
    if (set.length == 1) {
      fivek.add(hand);
      return;
    }

    final count = Map.fromEntries(set.map((element) {
      return MapEntry(
          element,
          hand.$1.codeUnits
              .where((card) => element.codeUnitAt(0) == card)
              .length);
    }));

    if (count.containsValue(4)) {
      fourk.add(hand);
      return;
    }
    if (count.containsValue(3)) {
      if (count.length == 2) {
        fullh.add(hand);
        return;
      }

      threek.add(hand);
      return;
    }

    if (count.values.where((element) => element == 2).length == 2) {
      twop.add(hand);
      return;
    }

    onep.add(hand);
  });

  final fullList = [
    ...high.sorted(sort),
    ...onep.sorted(sort),
    ...twop.sorted(sort),
    ...threek.sorted(sort),
    ...fullh.sorted(sort),
    ...fourk.sorted(sort),
    ...fivek.sorted(sort),
  ];

  int total = 0;

  for (int i = 0; i < fullList.length; i++) {
    // print(
    //     '${fullList.elementAt(i).$1}: ${fullList.elementAt(i).$2} * ${i + 1}');

    total += fullList.elementAt(i).$2 * (i + 1);
  }

  print(total);
}

const weights = [
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  'T',
  'J',
  'Q',
  'K',
  'A',
];

int sort((String, int) a, (String, int) b) {
  if (a.$1 == b.$1) return 0;

  for (int i = 0; i < a.$1.length; i++) {
    final a_i = a.$1[i], b_i = b.$1[i];
    if (a_i == b_i) continue;
    final weight_a = weights.indexOf(a_i) + 1,
        weight_b = weights.indexOf(b_i) + 1;

    return weight_a.compareTo(weight_b);
  }

  return 0;
}
