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

  for (final hand in hands) {
    final set = hand.$1.split('').toSet();
    int jokers = hand.$1.split('').where((element) => element == 'J').length;

    if (set.length == 5 && jokers == 0) {
      high.add(hand);
      continue;
    } else if (set.length == 5 && jokers == 1) {
      onep.add(hand);
      continue;
    }

    if (set.length == 1) {
      fivek.add(hand);
      continue;
    }

    final count = Map.fromEntries(set.map((element) {
      return MapEntry(
          element,
          hand.$1.codeUnits
              .where((card) => element.codeUnitAt(0) == card)
              .length);
    }));

    count.remove('J');

    if (count.containsValue(4) && jokers == 0) {
      fourk.add(hand);
      continue;
    } else if (count.containsValue(4) && jokers > 0) {
      fivek.add(hand);
      continue;
    }

    if (count.containsValue(3) && jokers == 0) {
      if (count.length == 2) {
        fullh.add(hand);
        continue;
      }

      threek.add(hand);
      continue;
    } else if (count.containsValue(3) && jokers == 1) {
      fourk.add(hand);
      continue;
    } else if (count.containsValue(3) && jokers == 2) {
      fivek.add(hand);
      continue;
    }

    if (count.values.where((element) => element == 2).length == 2 &&
        jokers == 0) {
      twop.add(hand);
      continue;
    } else if (count.values.where((element) => element == 2).length == 2 &&
        jokers > 0) {
      fullh.add(hand);
      continue;
    } else if (count.containsValue(2) && jokers == 1) {
      threek.add(hand);
      continue;
    } else if (count.containsValue(2) && jokers == 2) {
      fourk.add(hand);
      continue;
    } else if (count.containsValue(2) && jokers == 3) {
      fivek.add(hand);
      continue;
    }

    if (jokers == 0) {
      onep.add(hand);
      continue;
    }

    switch (jokers) {
      case 1:
        onep.add(hand);
        break;
      case 2:
        threek.add(hand);
        break;
      case 3:
        fourk.add(hand);
        break;
      case 4:
        fivek.add(hand);
        break;
      case 5:
        fivek.add(hand);
        break;
    }
  }

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
    total += fullList.elementAt(i).$2 * (i + 1);
  }

  print(total);
}

const weights = [
  'J',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  'T',
  'Q',
  'K',
  'A',
];

int sort((String, int) a, (String, int) b) {
  if (a.$1 == b.$1) return 0;

  for (int i = 0; i < a.$1.length; i++) {
    final aI = a.$1[i], bI = b.$1[i];
    if (aI == bI) continue;
    final weightA = weights.indexOf(aI) + 1, weightB = weights.indexOf(bI) + 1;

    return weightA.compareTo(weightB);
  }

  return 0;
}
