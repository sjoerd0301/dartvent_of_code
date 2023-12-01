part of aoc2021;

class Fish {
  Fish(this.day);

  int day;
  int amount = 1;

  bool simulate() {
    if (day != 0) {
      day--;
    } else {
      day = 6;
      return true;
    }
    return false;
  }
}

class day_6 extends d2021 {
  @override
  int get dayNo => 6;

  @override
  Future<void> part_1() async {
    Map<int, int> fishMap = {};

    List<int> ints =
        (data as List<String>)[0].split(',').map((e) => int.parse(e)).toList();

    for (final i in ints) {
      if (fishMap.containsKey(i)) {
        fishMap[i] = fishMap[i]! + 1;
      } else {
        fishMap[i] = 1;
      }
    }

    List<Fish> fish = [];
    fishMap.forEach((key, value) {
      final f = Fish(key);
      f.amount = value;
      fish.add(f);
    });

    for (int i = 1; i <= 80; i++) {
      Fish? newFish;

      for (final f in fish) {
        if (f.simulate()) {
          if (newFish == null) {
            newFish = Fish(8);
            newFish.amount = f.amount;
          } else {
            newFish.amount += f.amount;
          }
        }
      }

      if (newFish != null) {
        fish.add(newFish);
      }
    }

    int count = 0;

    for (final f in fish) {
      count += f.amount;
    }

    stdout.writeln('The answer is $count');
  }

  @override
  Future<void> part_2() async {
    Map<int, int> fishMap = {};

    List<int> ints =
        (data as List<String>)[0].split(',').map((e) => int.parse(e)).toList();

    for (final i in ints) {
      if (fishMap.containsKey(i)) {
        fishMap[i] = fishMap[i]! + 1;
      } else {
        fishMap[i] = 1;
      }
    }

    List<Fish> fish = [];
    fishMap.forEach((key, value) {
      final f = Fish(key);
      f.amount = value;
      fish.add(f);
    });

    for (int i = 1; i <= 256; i++) {
      Fish? newFish;

      for (final f in fish) {
        if (f.simulate()) {
          if (newFish == null) {
            newFish = Fish(8);
            newFish.amount = f.amount;
          } else {
            newFish.amount += f.amount;
          }
        }
      }

      if (newFish != null) {
        fish.add(newFish);
      }
    }

    int count = 0;

    for (final f in fish) {
      count += f.amount;
    }

    stdout.writeln('The answer is $count');
  }

  @override
  Future<void> prepareInput() async {
    data = await getParsedInput();
  }
}
