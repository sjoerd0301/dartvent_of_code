part of aoc2021;

class Node extends Comparable<Node> {
  int x, y, danger;

  Node(this.x, this.y, this.danger);

  Node? left, top, right, bottom;

  List<Node> get neighbors => [
        if (left != null) left!,
        if (top != null) top!,
        if (right != null) right!,
        if (bottom != null) bottom!,
      ];

  int? totalDanger;

  @override
  int compareTo(Node other) {
    if (totalDanger == null && other.totalDanger == null) return 0;
    if (totalDanger == null) return 1;
    if (other.totalDanger == null) return -1;

    return totalDanger!.compareTo(other.totalDanger!);
  }
}

class day_15 extends d2021 {
  @override
  int get dayNo => 15;

  @override
  Future<void> part_1() async {
    final grid = data as List<List<Node>>;
    int height = grid.length, width = grid[0].length;
    final start = grid[0][0], end = grid[height - 1][width - 1];

    List<Node> nodes = grid.flattened.toList();

    final path = findPath(nodes, start);

    stdout.writeln('The answer is ${path[end]}');
  }

  Map<Node, int?> findPath(List<Node> nodes, Node start) {
    Map<Node, Node?> previous = {start: null};
    Map<Node, int?> distances = {start: 0};
    HeapPriorityQueue<Node> queue =
        HeapPriorityQueue<Node>((a, b) => a.compareTo(b));

    start.totalDanger = 0;

    for (Node n in nodes) {
      if (n != start) {
        distances[n] = null;
        previous[n] = null;
      }

      queue.add(n);
    }

    while (queue.isNotEmpty) {
      Node n = queue.removeFirst();

      for (Node node in n.neighbors) {
        if (!queue.contains(node)) {
          continue;
        }
        int d = distances[n]! + node.danger;
        if (distances[node] == null ||
            (distances[node] != null && d < distances[node]!)) {
          distances[node] = d;
          previous[node] = n;

          queue.remove(node);
          node.totalDanger = d;
          queue.add(node);
        }
      }
    }

    return distances;
  }

  @override
  Future<void> part_2() async {
    List<List<Node>> grid = data as List<List<Node>>;
    int height = grid.length, width = grid[0].length;
    int newHeight = height * 5, newWidth = width * 5;

    final mask = [
      [0, 1, 2, 3, 4],
      [1, 2, 3, 4, 5],
      [2, 3, 4, 5, 6],
      [3, 4, 5, 6, 7],
      [4, 5, 6, 7, 8],
    ];
    //copy grid
    List<List<Node>> newGrid = [];

    for (int y = 0; y < newWidth; y++) {
      newGrid.add([]);
      for (int x = 0; x < newHeight; x++) {
        final maskY = y ~/ height;
        final maskX = x ~/ width;
        final oldGridpositionHeight = y % height;
        final oldGridpositionWidth = x % width;

        final oldNode = grid[oldGridpositionHeight][oldGridpositionWidth];

        int newDanger = (oldNode.danger + mask[maskY][maskX]) % 9;

        if (newDanger == 0) newDanger = 9;

        newGrid[y].add(Node(x, y, newDanger));

        if (y != 0) {
          newGrid[y][x].top = newGrid[y - 1][x];
          newGrid[y - 1][x].bottom = newGrid[y][x];
        }
        if (x != 0) {
          newGrid[y][x].left = newGrid[y][x - 1];
          newGrid[y][x - 1].right = newGrid[y][x];
        }
      }
    }

    final start = newGrid[0][0], end = newGrid[newHeight - 1][newWidth - 1];

    List<Node> nodes = newGrid.flattened.toList();

    final path = findPath(nodes, start);

    stdout.writeln('The answer is ${path[end]}');
  }

  @override
  Future<void> prepareInput() async {
    final tmp = await getParsedInput();
    final toNode = tmp.map((e) => e.trim().split('').toList()).toList();

    data = <List<Node>>[];

    for (int y = 0; y < toNode.length; y++) {
      data.add(<Node>[]);
      for (int x = 0; x < toNode[y].length; x++) {
        data[y].add(Node(x, y, int.parse(toNode[y][x])));
        if (y != 0) {
          data[y][x].top = data[y - 1][x];
          data[y - 1][x].bottom = data[y][x];
        }
        if (x != 0) {
          data[y][x].left = data[y][x - 1];
          data[y][x - 1].right = data[y][x];
        }
      }
    }
  }
}
