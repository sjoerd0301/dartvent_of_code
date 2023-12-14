import 'dart:io';

void main() {
  final file = File('data.txt');

  final input = file.readAsLinesSync();
  final parsed = transpose(input.map((e) => e.split('')).toList());

  int total = 0;

  for (int row = 0; row < parsed.length; row++) {
    int weight = 0;
    int nextEmpty = 0;
    int length = parsed[row].length;
    for (int col = 0; col < parsed[row].length; col++) {
      String cur = parsed[row][col];
      if (cur == 'O') {
        if (nextEmpty < col) {
          weight += length - (nextEmpty);
          nextEmpty += 1;
        } else if (nextEmpty == col) {
          weight += length - (nextEmpty);
          nextEmpty = col + 1;
        } else {
          nextEmpty = col + 1;
        }
      } else if (cur == '#') {
        nextEmpty = col + 1;
      }
    }
    total += weight;
  }

  print(total);
}

List<List<String>> transpose(List<List<String>> data) {
  List<List<String>> newData = <List<String>>[];

  for (int i = 0; i < data[0].length; i++) {
    final tmp = <String>[];
    for (int j = 0; j < data.length; j++) {
      tmp.add(data[j][i]);
    }
    newData.add(tmp);
  }

  return newData;
}
