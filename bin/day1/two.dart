import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final file = File('data.txt');

  String text = file.readAsStringSync();

  final lines = text.split('\n');

  final regex =
      RegExp('(one|two|three|four|five|six|seven|eight|nine|zero)|\\d');

  print(lines.map((e) {
    final first = regex.allMatches(e).first[0]!;
    final last = regex.allMatches(e).last[0]!;

    int f = get_number(first), l = get_number(last);

    return int.parse('$f$l');
  }).sum);
}

int get_number(String number) {
  int? n = int.tryParse(number);
  if (n != null) return n;

  return switch (number) {
    'one' => 1,
    'two' => 2,
    'three' => 3,
    'four' => 4,
    'five' => 5,
    'six' => 6,
    'seven' => 7,
    'eight' => 8,
    'nine' => 9,
    _ => 0
  };
}
