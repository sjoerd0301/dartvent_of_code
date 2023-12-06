import 'dart:io';

void main() {
  final file = File('data.txt');

  final input = file.readAsLinesSync();

  final time = int.parse(input[0].split(':')[1].replaceAll(' ', ''));
  final distance = int.parse(input[1].split(':')[1].replaceAll(' ', ''));

  int total = 0;

  for (int x = 0; x < time; x++) {
    if ((time - x) * x > distance) {
      total++;
    }
  }

  print(total);
}
