part of aoc2021;

class Day_4 extends d2021 {
  @override
  int get dayNo => 4;

  @override
  Future<void> part_1() async {
    List<int> numbers;
    List<Array2d> cards = [], filledCards = [];

    List<String> input = data;

    input = input.where((element) => element.isNotEmpty).toList();

    numbers = input[0].split(',').map((e) => int.parse(e)).toList();

    int cardAmount = (input.length - 1) ~/ 5;

    for (int i = 0; i < cardAmount; i++) {
      cards.add(Array2d(input
          .skip(1 + (5 * i))
          .take(5)
          .map((e) => Array(e
              .split(' ')
              .where((element) => element.isNotEmpty)
              .map((e) => num.parse(e.trim()).toDouble())
              .toList()))
          .toList()));

      filledCards.add(Array2d.fixed(5, 5, initialValue: 1));
    }

    bool isFinished = false;

    for (int number in numbers) {
      if (isFinished) break;
      for (int i = 0; i < cardAmount; i++) {
        if (isFinished) break;
        for (int x = 0; x < 5; x++) {
          for (int y = 0; y < 5; y++) {
            if (cards[i][x][y].toInt() == number) {
              filledCards[i][x][y] = 0;
            }
          }
        }
        for (int r = 0; r < 5; r++) {
          int rowCount = filledCards[i][r]
              .reduce((previousValue, element) => previousValue + element)
              .toInt();
          int colCount = filledCards[i]
              .getColumn(r)!
              .reduce((previousValue, element) => previousValue + element)
              .toInt();

          if (rowCount == 0 || colCount == 0) {
            Array2d sum = cards[i] * filledCards[i];

            int s = arraySum(
                    Array(sum.map((element) => arraySum(element)).toList()))
                .toInt();

            stdout.writeln('The answer is: ${s * number}');
            isFinished = true;
            break;
          }
        }
      }
    }
  }

  @override
  Future<void> part_2() async {
    List<int> numbers;
    List<Array2d> cards = [], filledCards = [];

    List<String> input = data;

    input = input.where((element) => element.isNotEmpty).toList();

    numbers = input[0].split(',').map((e) => int.parse(e)).toList();

    int cardAmount = (input.length - 1) ~/ 5;

    for (int i = 0; i < cardAmount; i++) {
      cards.add(Array2d(input
          .skip(1 + (5 * i))
          .take(5)
          .map((e) => Array(e
              .split(' ')
              .where((element) => element.isNotEmpty)
              .map((e) => num.parse(e.trim()).toDouble())
              .toList()))
          .toList()));

      filledCards.add(Array2d.fixed(5, 5, initialValue: 1));
    }

    bool isFinished = false;

    for (int number in numbers) {
      if (isFinished) break;
      for (int i = cardAmount - 1; i >= 0; i--) {
        for (int x = 0; x < 5; x++) {
          for (int y = 0; y < 5; y++) {
            if (cards[i][x][y].toInt() == number) {
              filledCards[i][x][y] = 0;
            }
          }
        }

        for (int r = 0; r < 5; r++) {
          if (isFinished) break;
          int rowCount = filledCards[i][r]
              .reduce((previousValue, element) => previousValue + element)
              .toInt();
          int colCount = filledCards[i]
              .getColumn(r)!
              .reduce((previousValue, element) => previousValue + element)
              .toInt();

          if (rowCount == 0 || colCount == 0) {
            Array2d sum = cards[i] * filledCards[i];

            int s = arraySum(
                    Array(sum.map((element) => arraySum(element)).toList()))
                .toInt();

            if (cardAmount == 1) {
              stdout.writeln('The answer is: ${s * number}');
              isFinished = true;
            } else {
              cards.removeAt(i);
              filledCards.removeAt(i);
              cardAmount--;
            }
            break;
          }
        }
      }
    }
  }

  @override
  Future<void> prepareInput() async {
    data = await getParsedInput();
  }
}
