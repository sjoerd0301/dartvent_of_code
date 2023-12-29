import 'dart:io';

void main() {
  final file = File('data.txt');

  final input = file.readAsLinesSync().map((e) {
    final splits = e.split(' @ ');

    final line = splits.first.split(', ').map((e) => double.parse(e)).toList();
    final direction =
        splits.last.split(', ').map((e) => double.parse(e)).toList();

    return ((line[0], line[1]), (direction[0], direction[1]));
  }).toList();

  int total = 0;

  for (int i = 0; i < input.length; i++) {
    for (int j = i + 1; j < input.length; j++) {
      final intersection =
          intersect(input[i].$1, input[i].$2, input[j].$1, input[j].$2);
      if (intersection != null &&
          inBounds(intersection) &&
          [input[i], input[j]].every((e) =>
              (intersection.$1 - e.$1.$1) * e.$2.$1 >= 0 &&
              (intersection.$2 - e.$1.$2) * e.$2.$2 >= 0)) {
        total++;
      }
    }
  }

  print(total);
}

bool inBounds((double, double) input) =>
    200000000000000 <= input.$1 &&
    input.$1 <= 400000000000000 &&
    200000000000000 <= input.$2 &&
    input.$2 <= 400000000000000;

(double, double)? intersect((double, double) line1, (double, double) dir1,
    (double, double) line2, (double, double) dir2) {
  // Calculate the determinant of the direction vectors
  double det = dir1.$1 * dir2.$2 - dir1.$2 * dir2.$1;

  // If the determinant is zero, the lines are parallel and may or may not intersect
  if (det != 0) {
    double t1 =
        ((line2.$1 - line1.$1) * dir2.$2 - (line2.$2 - line1.$2) * dir2.$1) /
            det;

    // Calculate the intersection point
    double x = line1.$1 + t1 * dir1.$1;
    double y = line1.$2 + t1 * dir1.$2;

    return (x, y);
  }

  return null;
}
