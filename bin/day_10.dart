part of days;

class Chunk {
  String char;
  List<Chunk> chunks = [];

  Chunk(this.char);
  Chunk? parent;
  Chunk? initial;
  bool closed = false, error = false;

  Chunk add(Chunk chunk) {
    chunk.parent = this;
    chunks.add(chunk);

    return chunk;
  }
}

class day_10 extends Day {
  @override
  int get dayNo => 10;

  @override
  Future<void> part_2() async {
    final input = data as List<String>;

    final open = ['(', '[', '{', '<'], close = [')', ']', '}', '>'];
    final points = {'(': 1, '[': 2, '{': 3, '<': 4};

    final scores = <int>[];

    for (int j = 0; j < input.length; j++) {
      final line = input[j];
      Chunk? lastChunk;
      List<Chunk> chunks = [];

      final splitted = line.split('');
      for (int i = 0; i < splitted.length; i++) {
        final char = splitted[i];

        if (lastChunk == null) {
          lastChunk = Chunk(char);
          chunks.add(lastChunk);
        } else if (open.contains(char)) {
          lastChunk = lastChunk.add(Chunk(char));
          chunks.add(lastChunk);
        } else if (close.contains(char) &&
            open.indexOf(lastChunk.char) == close.indexOf(char)) {
          lastChunk.closed = true;
          lastChunk = lastChunk.parent;
        } else if (close.contains(char) &&
            open.indexOf(lastChunk.char) != close.indexOf(char)) {
          lastChunk.error = true;
          break;
        }

        if (i == splitted.length - 1 &&
            chunks.any((element) => !element.closed)) {
          final toClose = chunks.where((e) => !e.closed).toList().reversed;

          scores.add(toClose.fold<int>(0, (p, e) => (p * 5) + points[e.char]!));
        }
      }
    }

    scores.sort();

    stdout.writeln('The answer is ${scores[scores.length ~/ 2]}');
  }

  @override
  Future<void> part_1() async {
    final input = data as List<String>;

    final open = ['(', '[', '{', '<'], close = [')', ']', '}', '>'];
    final points = {')': 3, ']': 57, '}': 1197, '>': 25137};

    int count = 0;

    for (final line in input) {
      Chunk? lastChunk;

      final splitted = line.split('');
      for (int i = 0; i < splitted.length; i++) {
        final char = splitted[i];

        if (lastChunk == null) {
          lastChunk = Chunk(char);
        } else if (open.contains(char)) {
          lastChunk = lastChunk.add(Chunk(char));
        } else if (close.contains(char) &&
            open.indexOf(lastChunk.char) == close.indexOf(char)) {
          lastChunk.closed = true;
          lastChunk = lastChunk.parent;
        } else if (close.contains(char) &&
            open.indexOf(lastChunk.char) != close.indexOf(char)) {
          count += points[char]!;
          lastChunk.error = true;
          break;
        }
      }
    }

    stdout.writeln('The answer is $count');
  }

  @override
  int get parts => 2;

  @override
  Future<void> prepareInput() async {
    data = await getParsedInput();
  }
}
