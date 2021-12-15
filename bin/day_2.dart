part of days;

class Day2 extends Day {
  @override
  int get dayNo => 2;

  @override
  int get parts => 2;

  @override
  Future<void> prepareInput() async {
    String rawData = await getInput(dayNo);
    List<String> rawLines = LineSplitter().convert(rawData);
    data = rawLines.map((e) {
      var list = e.split(' ');

      direction dir = direction.values.firstWhere(
          (element) => element.toString() == 'direction.${list[0]}');
      return MapEntry<direction, int>(dir, int.parse(list[1]));
    }).toList();
  }

  @override
  Future<void> part_1() async {
    List<MapEntry<direction, int>> rawMap =
        data as List<MapEntry<direction, int>>;

    int horiz = 0, depth = 0;

    rawMap.forEach((element) {
      switch (element.key) {
        case direction.forward:
          horiz += element.value;
          break;
        case direction.down:
          depth += element.value;
          break;
        case direction.up:
          depth -= element.value;
          break;
      }
    });

    stdout.writeln('The answer is: ${depth * horiz}');
  }

  @override
  Future<void> part_2() async {
    List<MapEntry<direction, int>> rawMap =
        data as List<MapEntry<direction, int>>;
    int horiz = 0, depth = 0, aim = 0;

    rawMap.forEach((element) {
      switch (element.key) {
        case direction.forward:
          horiz += element.value;
          depth += aim * element.value;
          break;
        case direction.down:
          aim += element.value;
          break;
        case direction.up:
          aim -= element.value;
          break;
      }
    });

    stdout.writeln('The answer is: ${depth * horiz}');
  }
}

enum direction { forward, down, up }
