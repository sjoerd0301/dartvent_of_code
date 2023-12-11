import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final file = File('data.txt');

  final input = file.readAsLinesSync();
  var data = input.map((e) => e.split('').toList()).toList();
  addRows(data);
  print('completed adding rows');
  data = transpose(data);
  addRows(data);

  final galaxies = data
      .mapIndexed((y, element) =>
          element.mapIndexed((x, element) => element == '#' ? (x, y) : null))
      .fold(
    <(int, int)>[],
    (p, e) => [
      ...p,
      ...e.fold(<(int, int)>[], (previousValue, element) {
        final value = previousValue.toList();
        if (element != null) value.add(element);
        return value;
      }),
    ],
  );

  final distances = <int>[];

  final yRow = data.map((e) => e.first);

  for (int i = 0; i < galaxies.length; i++) {
    for (int j = i + 1; j < galaxies.length; j++) {
      final (x_1, y_1) = galaxies[i];
      final (x_2, y_2) = galaxies[j];

      final xStart = x_1 < x_2 ? x_1 : x_2;
      final xEnd = x_1 < x_2 ? x_2 : x_1;

      final yStart = y_1 < y_2 ? y_1 : y_2;
      final yEnd = y_1 < y_2 ? y_2 : y_1;

      final _x = data[y_1].skip(xStart).take(xEnd - xStart).fold(0,
          (previousValue, element) => previousValue + (element == '*' ? 2 : 1));

      final _y = yRow.skip(yStart).take(yEnd - yStart).fold(0,
          (previousValue, element) => previousValue + (element == '*' ? 2 : 1));

      distances.add(_x + _y);
    }
  }

  print(distances.sorted((a, b) => a.compareTo(b)).sum);
}

List<List<String>> transpose(List<List<String>> data) {
  List<List<String>> newData = <List<String>>[];

  for (int i = 0; i < data[0].length; i++) {
    List<String> tmp = [];
    for (int j = 0; j < data.length; j++) {
      tmp.add(data[j][i]);
    }
    newData.add(tmp);
  }

  return newData;
}

addRows(List<List<String>> data) {
  for (int i = 0; i < data.length; i++) {
    if (data[i].every((element) => element == '.' || element == '*')) {
      data[i] = data[i].map((e) => '*').toList();
    }
  }
}
