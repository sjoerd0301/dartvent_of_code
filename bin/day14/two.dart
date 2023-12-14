import 'dart:io';

final cache = <String>{};

void main() {
  final file = File('data.txt');

  final input = file.readAsLinesSync();
  final parsed = input.map((e) => e.split('')).toList();

  var tmp = parsed;
  var firstRepeating = -1;

  for (int i = 0; i < 1000000000; i++) {
    final key = tmp.map((e) => e.join('')).join('|');

    if (cache.contains(key)) {
      firstRepeating = cache.toList().indexOf(key) - 1;
      break;
    } else {
      tmp = cycle(tmp);
      cache.add(key);
    }
  }

  final element = cache
      .elementAt(firstRepeating +
          (1000000000 - firstRepeating) % (cache.length - firstRepeating - 1))
      .split('|')
      .map((e) => e.split('').toList())
      .toList();

  print(calculateLoad(transpose(element)));
}

int calculateLoad(List<List<String>> data) {
  int total = 0;

  for (int row = 0; row < data.length; row++) {
    int weight = 0;
    int length = data[row].length;
    for (int col = 0; col < data[row].length; col++) {
      String cur = data[row][col];
      if (cur == 'O') {
        weight += length - col;
      }
    }
    total += weight;
  }

  return total;
}

List<List<String>> cycle(List<List<String>> parsed) {
  List<List<String>> data = transpose(parsed);
  shift(data);
  data = transpose(data);
  shift(data);
  data = transpose(data).map((e) => e.reversed.toList()).toList();
  shift(data);
  data = transpose(data.map((e) => e.reversed.toList()).toList())
      .map((e) => e.reversed.toList())
      .toList();
  shift(data);
  return data.map((e) => e.reversed.toList()).toList();
}

void shift(List<List<String>> parsed) {
  for (int row = 0; row < parsed.length; row++) {
    int nextEmpty = 0;
    for (int col = 0; col < parsed[row].length; col++) {
      if (parsed[row][col] == 'O') {
        if (nextEmpty < col) {
          parsed[row][nextEmpty] = 'O';
          parsed[row][col] = '.';
          nextEmpty += 1;
        } else if (nextEmpty == col) {
          nextEmpty = col + 1;
        } else {
          nextEmpty = col + 1;
        }
      } else if (parsed[row][col] == '#') {
        nextEmpty = col + 1;
      }
    }
  }
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
