part of days;

class Day1 extends Day {
  @override
  int get dayNo => 1;

  @override
  int get parts => 2;

  @override
  Future<void> prepareInput() async {
    List<int> lines = LineSplitter()
        .convert(await getInput(dayNo))
        .map((e) => int.parse(e))
        .toList();
  }

  @override
  Future<void> part_1() async {
    List<int> input = data as List<int>;
    int out = 0;
    var previous = input[0];
    for (var i = 1; i < input.length; i++) {
      if (input[i] > previous) {
        out++;
      }
      previous = input[i];
    }
    stdout.writeln('The answer is: $out');
  }

  @override
  Future<void> part_2() async {
    List<int> input = data as List<int>;
    int tmp = 0;
    int count = 0;

    await Stream.fromIterable(input).windowCount(3, 1).forEach((element) async {
      var list = await element.toList();

      if (list.length == 3) {
        int sum = list.reduce((value, element) => value + element);
        if (tmp < sum) {
          count++;
        }

        tmp = sum;
      }
    });

    stdout.writeln('The answer is: $count');
  }
}
