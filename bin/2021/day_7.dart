part of aoc2021;

class day_7 extends d2021 {
  @override
  int get dayNo => 7;
  @override
  Future<void> part_1() async {
    final input = data as List<int>;

    Map<int, int> map = {};

    for (int i in input) {
      if (map.containsKey(i)) {
        map[i] = map[i]! + 1;
      } else {
        map[i] = 1;
      }
    }

    var sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => map[k2]!.compareTo(map[k1]!));

    LinkedHashMap sortedMap = LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => map[k]);

    List<int> shortestDistance = [];

    for (final key in sortedMap.keys) {
      int totalDistance = 0;
      for (final item in sortedMap.entries) {
        final distance = (key - item.key).abs();

        totalDistance += item.value * distance as int;
      }

      shortestDistance.add(totalDistance);
    }

    shortestDistance.sort();

    stdout.writeln('the answer is ${shortestDistance[0]}');
  }

  @override
  Future<void> part_2() async {
    final input = data as List<int>;

    Map<int, int> map = {};

    for (int i in input) {
      if (map.containsKey(i)) {
        map[i] = map[i]! + 1;
      } else {
        map[i] = 1;
      }
    }

    input.sort();

    var sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => map[k2]!.compareTo(map[k1]!));

    LinkedHashMap<int, int> sortedMap = LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => map[k]!);

    List<int> shortestDistance = [];

    for (int i = input.first; i <= input.last; i++) {
      int totalDistance = 0;

      for (final item in sortedMap.entries) {
        int distance = (i - item.key).abs();
        int startDistance = distance;

        for (int j = 1; j < startDistance; j++) {
          distance += j;
        }

        totalDistance += item.value * distance;
      }

      shortestDistance.add(totalDistance);
    }

    shortestDistance.sort();

    stdout.writeln('the answer is ${shortestDistance[0]}');
  }

  @override
  Future<void> prepareInput() async {
    data = (await getParsedInput())[0]
        .split(',')
        .map((e) => int.parse(e))
        .toList();
  }
}
