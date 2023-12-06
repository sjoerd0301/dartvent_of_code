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
    final cur_t = time.elementAt(i);
    final cur_d = distance.elementAt(i);

    int options = 0;

    for (int x = 0; x < cur_t; x++) {
      if ((cur_t - x) * x > cur_d) {
        options++;
      }
    }

    total *= options;
  }

  print(total);
}
