import 'dart:io';

void main() {
  final file = File('data.txt');

  final input = file.readAsLinesSync();

  final regexWs = RegExp('\\s+');

  final time =
      input[0].split(':')[1].trim().split(regexWs).map((e) => int.parse(e));
  final distance =
      input[1].split(':')[1].trim().split(regexWs).map((e) => int.parse(e));

  int total = 1;

  for (int i = 0; i < time.length; i++) {
    final curT = time.elementAt(i);
    final curD = distance.elementAt(i);

    int options = 0;

    for (int x = 0; x < curT; x++) {
      if ((curT - x) * x > curD) {
        options++;
      }
    }

    total *= options;
  }

  print(total);
}
