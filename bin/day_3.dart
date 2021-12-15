part of days;

class Day3 extends Day {
  @override
  int get dayNo => 3;

  @override
  int get parts => 2;

  @override
  Future<void> prepareInput() async {
    List<String> preParseData = await getParsedInput();
    List<List<double>> splitList = preParseData
        .map((e) => e.split('').map((e) => double.parse(e)).toList())
        .toList();
    data = Array2d(splitList.map((e) => Array(e)).toList());
  }

  @override
  Future<void> part_1() async {
    Array2d input = data as Array2d;
    input = matrixTranspose(input);
    String most = '', least = '';

    input.forEach((element) {
      int count0 = 0, count1 = 0;
      element.forEach((element) {
        if (element < 1) {
          count0++;
        } else {
          count1++;
        }
      });

      if (count0 > count1) {
        most += '0';
        least += '1';
      } else {
        most += '1';
        least += '0';
      }
    });

    var convert = BaseConversion(from: base2, to: base10);

    int mostInt = int.parse(convert(most)),
        leastInt = int.parse(convert(least));

    stdout.writeln('The answer is ${mostInt * leastInt}');
  }

  @override
  Future<void> part_2() async {
    Array2d input = data as Array2d;
    Array2d oxy, co2;

    int count0 = 0, count1 = 0;
    input.getColumn(0)!.forEach((element) {
      if (element < 1) {
        count0++;
      } else {
        count1++;
      }
    });

    if (count0 > count1) {
      oxy = Array2d(input.where((element) => element[0] < 1).toList());
      co2 = Array2d(input.where((element) => element[0] > 0).toList());
    } else {
      co2 = Array2d(input.where((element) => element[0] < 1).toList());
      oxy = Array2d(input.where((element) => element[0] > 0).toList());
    }

    for (int i = 1; i < 12; i++) {
      count0 = 0;
      count1 = 0;
      if (oxy.length > 1) {
        oxy.getColumn(i)!.forEach((element) {
          if (element < 1) {
            count0++;
          } else {
            count1++;
          }
        });

        if (count0 > count1) {
          oxy = Array2d(oxy.where((element) => element[i] < 1).toList());
        } else if (count0 < count1) {
          oxy = Array2d(oxy.where((element) => element[i] > 0).toList());
        } else {
          oxy = Array2d(oxy.where((element) => element[i] > 0).toList());
        }
      }

      count0 = 0;
      count1 = 0;

      if (co2.length > 1) {
        co2.getColumn(i)!.forEach((element) {
          if (element < 1) {
            count0++;
          } else {
            count1++;
          }
        });

        if (count0 > count1) {
          co2 = Array2d(co2.where((element) => element[i] > 0).toList());
        } else if (count0 < count1) {
          co2 = Array2d(co2.where((element) => element[i] < 1).toList());
        } else {
          co2 = Array2d(co2.where((element) => element[i] < 1).toList());
        }
      }
    }

    String oxyString = oxy[0].map((element) => element.toInt()).join('');
    String co2String = co2[0].map((element) => element.toInt()).join('');

    var convert = BaseConversion(from: base2, to: base10);

    int mostInt = int.parse(convert(oxyString)),
        leastInt = int.parse(convert(co2String));

    stdout.writeln('The answer is ${mostInt * leastInt} ');
  }
}

//844
//3251