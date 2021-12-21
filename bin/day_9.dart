part of days;

class node {
  node(this.value);
  int value;
  int? basinId;

  node? left;
  node? right;
  node? top;
  node? bottom;
}

class day_9 extends Day {
  @override
  int get dayNo => 9;

  @override
  Future<void> part_1() async {
    int count = 0;

    final input = data as List<List<int>>;

    for (int y = 0; y < input.length; y++) {
      for (int x = 0; x < input[y].length; x++) {
        int top = y == 0 ? 10 : input[y - 1][x],
            right = x == input[y].length - 1 ? 10 : input[y][x + 1],
            bottom = y == input.length - 1 ? 10 : input[y + 1][x],
            left = x == 0 ? 10 : input[y][x - 1],
            cur = input[y][x];

        if (cur < top && cur < right && cur < bottom && cur < left) {
          count += (cur + 1);
        }
      }
    }

    stdout.writeln('The answer is $count');
  }

  @override
  Future<void> part_2() async {
    final input = (data as List<List<int>>)
        .map((e) => e.map((e) => node(e)).toList())
        .toList();

    for (int y = 0; y < input.length; y++) {
      for (int x = 0; x < input[y].length; x++) {
        if (y != 0 && input[y][x].value != 9) {
          final top = input[y - 1][x];
          if (top.value != 9) {
            input[y][x].top = top;
            top.bottom = input[y][x];
          }
        }
        if (x != 0) {
          final left = input[y][x - 1];
          if (left.value != 9) {
            input[y][x].left = left;
            left.right = input[y][x];
          }
        }
      }
    }

    int basinCounter = 0;
    int count;

    final flattened =
        input.flattened.where((element) => element.value != 9).toList();

    for (int i = 0; i < flattened.length; i++) {
      if (flattened[i].basinId == null) {
        basinCounter = setBasinId(flattened[i], basinCounter);
      }
    }

    final grouped = flattened.groupFoldBy<int?, int>(
        (element) => element.basinId,
        (previous, element) => (previous ?? 0) + 1);

    List<int> f = grouped.values.toList();
    f.sort((a, b) => b.compareTo(a));

    stdout.writeln('The answer is ${f[0] * f[1] * f[2]}');
  }

  int setBasinId(node node, int basinId) {
    node.basinId = basinId;
    if (node.bottom != null && node.bottom!.basinId == null) {
      setBasinId(node.bottom!, basinId);
    }
    if (node.left != null && node.left!.basinId == null) {
      setBasinId(node.left!, basinId);
    }
    if (node.right != null && node.right!.basinId == null) {
      setBasinId(node.right!, basinId);
    }
    if (node.top != null && node.top!.basinId == null) {
      setBasinId(node.top!, basinId);
    }

    return basinId + 1;
  }

  @override
  int get parts => 2;

  @override
  Future<void> prepareInput() async {
    data = (await getParsedInput())
        .map((e) => e.split('').map((e) => int.parse(e)).toList())
        .toList();
  }
}
