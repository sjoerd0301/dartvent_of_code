import 'dart:io';

void main() {
  final file = File('data.txt');

  final input = file.readAsLinesSync();

  final String instruction = input[0];

  final nodes = Map.fromEntries(input.skip(2).map((e) {
    final splits = e.split(' = ');
    final nodes = splits[1].replaceAll('(', '').replaceAll(')', '').split(', ');
    return MapEntry(splits[0], (nodes[0], nodes[1]));
  }));

  int totalSteps = 0;
  String currentNode = 'AAA';

  while (currentNode != 'ZZZ') {
    int currentstep = totalSteps % instruction.length;

    switch (instruction[currentstep]) {
      case 'L':
        currentNode = nodes[currentNode]!.$1;
      case 'R':
        currentNode = nodes[currentNode]!.$2;
    }

    totalSteps++;
  }

  print(totalSteps);
}
