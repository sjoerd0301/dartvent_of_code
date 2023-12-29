import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

void main() {
  final file = File('data.txt');

  final input = Map.fromEntries(
    file.readAsLinesSync().map(
      (e) {
        final splits = e.split(': ');

        return MapEntry(splits.first, splits.last.split(' '));
      },
    ),
  );

  for (final node in {...input.keys, ...input.values.flattened}) {
    final keys =
        input.entries.where((e) => e.value.contains(node)).map((e) => e.key);

    input[node] = input[node] == null
        ? keys.toList()
        : [...input[node]!, ...keys.toList()];
  }

  final g = Graph(Map.unmodifiable(input));
  final (one, two) = g.kargerMinCut();

  print(one * two);
}

class Graph {
  final Map<String, List<String>> adjList;

  Graph(this.adjList);

  (int, int) kargerMinCut() {
    int minCut = 999999999999999;

    int one = -1, two = -1;

    for (int i = 0; i < 1000000; i++) {
      int currentMinCut = -1, currentOne = -1, currentTwo = -1;
      (currentMinCut, currentOne, currentTwo) = kargerCut();

      if (currentMinCut < minCut) {
        minCut = currentMinCut;
        one = currentOne;
        two = currentTwo;
        if (minCut == 3) break;
      }
    }
    print(minCut);

    return (one, two);
  }

  (int, int, int) kargerCut() {
    // Clone the graph to avoid modifying the original graph
    Map<String, List<String>> clone = Map.from(
        adjList.map((key, value) => MapEntry(key, List<String>.from(value))));

    while (clone.length > 2) {
      String u = clone.keys.elementAt(Random().nextInt(clone.length));
      List<String> neighbors = clone[u]!;
      String v = neighbors.elementAt(Random().nextInt(neighbors.length));

      final toRemove = clone.remove(u)!;
      final toUpdate = clone.remove(v)!;

      final newKey = '$u,$v';
      final newValue = {...toRemove, ...toUpdate}.toList();

      clone[newKey] = newValue;

      for (final key in clone.keys) {
        if (clone[key]!.contains(u) || clone[key]!.contains(v)) {
          clone[key]!.removeWhere((element) => [u, v].contains(element));
          clone[key]!.add(newKey);
        }
        if (key == newKey) {
          clone[key]!.remove(key);
        }
      }
    }

    // The remaining graph has two vertices, return the number of edges between them
    int cuts = (clone.entries.first.value.first.split(',').toSet().length -
            clone.entries.last.value.last.split(',').toSet().length)
        .abs();

    return (
      cuts,
      clone.entries.first.value.first.split(',').toSet().length,
      clone.entries.last.value.last.split(',').toSet().length
    );
  }
}
