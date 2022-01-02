part of days;

class octo {
  octo(this.level);

  int level;
  bool hasFlashed = false;

  void flash() {
    if (hasFlashed || level <= 9) return;
    hasFlashed = true;

    for (int i = 0; i < neighbors.length; i++) {
      neighbors[i].level++;
      if (neighbors[i].level > 9) neighbors[i].flash();
    }

    level = 0;
  }

  List<octo> neighbors = [];
}

class day_11 extends Day {
  @override
  int get dayNo => 11;

  @override
  Future<void> part_1() async {
    final input = data as List<List<octo>>;

    int count = 0;

    for (int i = 0; i < 100; i++) {
      for (int y = 0; y < input.length; y++) {
        for (int x = 0; x < input[y].length; x++) {
          if (input[y][x].hasFlashed) {
            input[y][x].level = 0;
          }

          input[y][x].level++;
          input[y][x].hasFlashed = false;
        }
      }

      for (int y = 0; y < input.length; y++) {
        for (int x = 0; x < input[y].length; x++) {
          input[y][x].flash();
        }
      }

      count += input.flattened.where((element) => element.hasFlashed).length;
    }

    stdout.writeln('The answer is $count');
  }

  @override
  Future<void> part_2() async {
    final input = data as List<List<octo>>;

    int count = 0;

    for (int i = 0; i < 1000; i++) {
      for (int y = 0; y < input.length; y++) {
        for (int x = 0; x < input[y].length; x++) {
          if (input[y][x].hasFlashed) {
            input[y][x].level = 0;
          }

          input[y][x].level++;
          input[y][x].hasFlashed = false;
        }
      }

      for (int y = 0; y < input.length; y++) {
        for (int x = 0; x < input[y].length; x++) {
          input[y][x].flash();
        }
      }

      if (input.flattened.where((element) => element.hasFlashed).length ==
          100) {
        stdout.writeln('The answer is ${i + 1}');
        break;
      }
    }
  }

  @override
  Future<void> prepareInput() async {
    data = (await getParsedInput())
        .map((e) => e.split('').map((e) => octo(int.parse(e))).toList())
        .toList();

    for (int y = 0; y < data.length; y++) {
      for (int x = 0; x < data[y].length; x++) {
        if (x != 0) {
          data[y][x].neighbors.add(data[y][x - 1]);
          data[y][x - 1].neighbors.add(data[y][x]);
        }
        if (y != 0) {
          if (x != data[y].length - 1) {
            data[y][x].neighbors.add(data[y - 1][x + 1]);
            data[y - 1][x + 1].neighbors.add(data[y][x]);
          }
          data[y][x].neighbors.add(data[y - 1][x]);
          data[y - 1][x].neighbors.add(data[y][x]);
        }
        if (x != 0 && y != 0) {
          data[y][x].neighbors.add(data[y - 1][x - 1]);
          data[y - 1][x - 1].neighbors.add(data[y][x]);
        }
      }
    }
  }
}
