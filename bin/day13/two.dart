import 'dart:io';
import 'package:collection/collection.dart';
import 'dart:math';

void main() {
  final file = File('data.txt');

  final input = file.readAsStringSync().split('\n\n');
  final parsed =
      input.map((e) => e.split('\n').map((e) => e.split('').toList()).toList());

  print(parsed.map((e) => check(e)).sum);
}

List<String> transpose(List<List<String>> data) {
  List<String> newData = <String>[];

  for (int i = 0; i < data[0].length; i++) {
    String tmp = '';
    for (int j = 0; j < data.length; j++) {
      tmp += data[j][i];
    }
    newData.add(tmp);
  }

  return newData;
}

int check(List<List<String>> data) {
  final v = findmirror(data.map((e) => e.join('')).toList()) * 100;

  if (v == 0) {
    return findmirror(transpose(data));
  }

  return v;
}

int findmirror(List<String> data) {
  for (int i = 1; i < data.length; i++) {
    List<String> above = data.sublist(0, i).reversed.toList();
    List<String> below = data.sublist(i).toList();

    final minLen = min(above.length, below.length);
    above = minLen == above.length ? above : above.sublist(0, minLen);
    below = (minLen == below.length ? below : below.sublist(0, minLen));

    int diff = above.fold(0, (previousValue, row) {
      final other = below[above.indexOf(row)].split('');
      return previousValue +
          row.split('').mapIndexed((i, e) => e == other[i] ? 0 : 1).sum;
    });

    if (diff == 1) {
      return i;
    }
  }
  return 0;
}
