part of aoc2021;

class Line {
  Point start;
  Point end;

  Line(this.start, this.end);
}

class day_5 extends d2021 {
  @override
  int get dayNo => 5;

  @override
  Future<void> part_1() async {
    int maxWidth = 0, maxHeight = 0;

    int lineCount = 0;
    List<Line> lines = [];

    for (String line in data as List<String>) {
      final parsedLine = line.split(' -> ');
      final c1 = parsedLine[0].split(','), c2 = parsedLine[1].split(',');
      Point p1 = Point(int.parse(c1[0]), int.parse(c1[1]));
      Point p2 = Point(int.parse(c2[0]), int.parse(c2[1]));

      maxWidth = max(p2.x, max(maxWidth, p1.x)) as int;
      maxHeight = max(p2.y, max(maxHeight, p1.y)) as int;

      lines.add(Line(p1, p2));
    }

    List<List<int>> grid = [];

    for (int y = 0; y <= maxHeight; y++) {
      grid.add(List.filled(maxWidth + 1, 0));
    }

    for (Line line in lines) {
      Point p1 = line.start;
      Point p2 = line.end;

      if (p1.x == p2.x || p1.y == p2.y) {
        lineCount++;
        int minX = min(p1.x, p2.x) as int, maxX = max(p1.x, p2.x) as int;
        int minY = min(p1.y, p2.y) as int, maxY = max(p1.y, p2.y) as int;

        if (minX == maxX) {
          for (int i = minY; i <= maxY; i++) {
            grid[i][minX]++;
          }
        } else if (minY == maxY) {
          for (int i = minX; i <= maxX; i++) {
            grid[minY][i]++;
          }
        }
      }
    }

    int count = 0;

    for (int i = 0; i <= maxHeight; i++) {
      for (int j = 0; j <= maxWidth; j++) {
        if (grid[i][j] > 1) {
          count++;
        }
      }
    }

    List<int> list = [];
    for (final l in grid) {
      list.addAll(l);
    }

    stdout.writeln(
        'The answer is: ${list.where((element) => element >= 2).length} : $count');
  }

  @override
  Future<void> part_2() async {
    int maxWidth = 0, maxHeight = 0;

    int lineCount = 0;
    List<Line> lines = [];

    for (String line in data as List<String>) {
      final parsedLine = line.split(' -> ');
      final c1 = parsedLine[0].split(','), c2 = parsedLine[1].split(',');
      Point p1 = Point(int.parse(c1[0]), int.parse(c1[1]));
      Point p2 = Point(int.parse(c2[0]), int.parse(c2[1]));

      maxWidth = max(p2.x, max(maxWidth, p1.x)) as int;
      maxHeight = max(p2.y, max(maxHeight, p1.y)) as int;

      lines.add(Line(p1, p2));
    }

    List<List<int>> grid = [];

    for (int y = 0; y <= maxHeight; y++) {
      grid.add(List.filled(maxWidth + 1, 0));
    }

    for (Line line in lines) {
      Point p1 = line.start;
      Point p2 = line.end;

      if (p1.x == p2.x || p1.y == p2.y) {
        lineCount++;
        int minX = min(p1.x, p2.x) as int, maxX = max(p1.x, p2.x) as int;
        int minY = min(p1.y, p2.y) as int, maxY = max(p1.y, p2.y) as int;

        if (minX == maxX) {
          for (int i = minY; i <= maxY; i++) {
            grid[i][minX]++;
          }
        } else if (minY == maxY) {
          for (int i = minX; i <= maxX; i++) {
            grid[minY][i]++;
          }
        }
      } else {
        int minX = min(p1.x, p2.x) as int, maxX = max(p1.x, p2.x) as int;
        int minY = min(p1.y, p2.y) as int, maxY = max(p1.y, p2.y) as int;
        int length = maxX - minX;

        if (p1.x > p2.x && p1.y > p2.y || p1.x < p2.x && p1.y < p2.y) {
          //ltr
          for (int i = 0; i <= length; i++) {
            grid[minY + i][minX + i]++;
          }
        } else {
          //rtl
          for (int i = 0; i <= length; i++) {
            grid[minY + i][maxX - i]++;
          }
        }
      }
    }

    int count = 0;

    for (int i = 0; i <= maxHeight; i++) {
      for (int j = 0; j <= maxWidth; j++) {
        if (grid[i][j] > 1) {
          count++;
        }
      }
    }

    List<int> list = [];
    for (final l in grid) {
      list.addAll(l);
    }

    stdout.writeln(
        'The answer is: ${list.where((element) => element >= 2).length} : $count');
  }

  @override
  Future<void> prepareInput() async {
    data = await getParsedInput();
  }
}
