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

  final currentNodes = nodes.keys.where((element) => element.endsWith('A'));

  print(findLCMOfList(currentNodes.map((e) {
    int totalSteps = 0;
    String currentNode = e;

    while (!currentNode.endsWith('Z')) {
      int currentstep = totalSteps % instruction.length;

      switch (instruction[currentstep]) {
        case 'L':
          currentNode = nodes[currentNode]!.$1;
        case 'R':
          currentNode = nodes[currentNode]!.$2;
      }

      totalSteps++;
    }

    return totalSteps;
  })));
}

int findGCD(int a, int b) {
  while (b != 0) {
    int temp = b;
    b = a % b;
    a = temp;
  }
  return a;
}

int findLCM(int a, int b) {
  return (a * b) ~/ findGCD(a, b);
}

int findLCMOfList(Iterable<int> numbers) {
  int lcm = numbers.first;

  for (int i = 0; i < numbers.length - 1; i++) {
    lcm = findLCM(lcm, numbers.elementAt(i));
  }

  return lcm;
}
