part of days;

class day_8 extends Day {
  @override
  int get dayNo => 8;
  @override
  Future<void> part_1() async {
    final tmpData =
        (data as List<List<String>>).map((e) => e[0].split(' ')).toList();

    final mask = [2, 3, 4, 7];

    int count = 0;
    tmpData.forEach((element) {
      element.forEach((element) {
        if (mask.contains(element.length)) {
          count++;
        }
      });
    });

    stdout.writeln('The answer is: $count');
  }

  @override
  Future<void> part_2() async {
    List<List<List<String>>> tmpData = (data as List<List<String>>)
        .map((e) => e.map((e) => e.split(' ').toList()).toList())
        .toList();

    List<String> allSegments = ['a', 'b', 'c', 'd', 'e', 'f', 'g'];

    Map<String, int> mask = {
      'abcefg': 0,
      'cf': 1,
      'acdeg': 2,
      'acdfg': 3,
      'bcdf': 4,
      'abdfg': 5,
      'abdefg': 6,
      'acf': 7,
      'abcdefg': 8,
      'abcdfg': 9,
    };

    int count = 0;

    for (final list in tmpData) {
      List<String> mapping = createMapping(list[0]);

      String digits = '';

      for (String digit in list[1]) {
        String newDigit = '';
        digit.split('').forEach((element) {
          newDigit += allSegments[mapping.indexOf(element)];
        });

        final sortedSegments = newDigit.split('');
        sortedSegments.sort();

        digits += '${mask[sortedSegments.join()]}';
      }

      count += int.parse(digits);
    }

    stdout.writeln('The answer is: $count');
  }

  List<String> createMapping(List<String> mapping) {
    List<String> allSegments = ['a', 'b', 'c', 'd', 'e', 'f', 'g'];
    List<String> unusedSegments = ['a', 'b', 'c', 'd', 'e', 'f', 'g'];

    List<String> segmentMapping = List.filled(7, '');

    String one = mapping.singleWhere((element) => element.length == 2);
    one.split('').forEach((element) {
      segmentMapping[2] += element;
      segmentMapping[5] += element;
      unusedSegments.remove(element);
    });

    String seven = mapping.singleWhere((element) => element.length == 3);
    seven.split('').forEach((element) {
      if (unusedSegments.contains(element)) {
        segmentMapping[0] += element;
        unusedSegments.remove(element);
      }
    });

    String four = mapping.singleWhere((element) => element.length == 4);
    four.split('').forEach((element) {
      if (unusedSegments.contains(element)) {
        segmentMapping[1] += element;
        segmentMapping[3] += element;
        unusedSegments.remove(element);
      }
    });

    String leftover = unusedSegments.join('');
    segmentMapping[4] += leftover;
    segmentMapping[6] += leftover;

    String zero = mapping.singleWhere((element) =>
        element.length == 6 &&
        !(element.contains(segmentMapping[1][0]) &&
            element.contains(segmentMapping[1][1])));

// 6, 9 or 0
    allSegments.forEach((element) {
      if (!zero.contains(element)) {
        segmentMapping[3] = element;
        segmentMapping[1] = segmentMapping[1].replaceAll(element, '');
      }
    });

    String six = mapping.singleWhere((element) =>
        element.length == 6 &&
        !(element.contains(segmentMapping[2][0]) &&
            element.contains(segmentMapping[2][1])));

    allSegments.forEach((element) {
      if (!six.contains(element)) {
        segmentMapping[2] = element;
        segmentMapping[5] = segmentMapping[5].replaceAll(element, '');
      }
    });

    String nine = mapping.singleWhere(
        (element) => element.length == 6 && ![zero, six].contains(element));

    allSegments.forEach((element) {
      if (!nine.contains(element)) {
        segmentMapping[4] = element;
        segmentMapping[6] = segmentMapping[6].replaceAll(element, '');
      }
    });

    return segmentMapping;
  }

  @override
  int get parts => 2;

  @override
  Future<void> prepareInput() async {
    data = (await getParsedInput()).map((e) => e.split(' | ')).toList();
  }
}
