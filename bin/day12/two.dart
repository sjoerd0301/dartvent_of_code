import 'dart:io';
import 'package:collection/collection.dart';
import 'dart:math';

final cache = <String, int>{};

void main() {
  final file = File('data.txt');

  final input = file.readAsLinesSync();

  final data = input.map((e) {
    final splits = e.split(' ');
    final num = splits[1].split(',').map((e) => int.parse(e)).toList();
    final line =
        '${splits[0]}?${splits[0]}?${splits[0]}?${splits[0]}?${splits[0]}';
    final nums = [
      ...num,
      ...num,
      ...num,
      ...num,
      ...num,
    ];
    return (line, nums);
  });

  print(data.map((e) => generate(e.$1, e.$2)).sum);
}

final eq = const ListEquality().equals;

int generate(String data, List<int> nums) {
  if (data == "") {
    return nums.isEmpty ? 1 : 0;
  }

  if (nums.isEmpty) {
    return data.contains("#") ? 0 : 1;
  }

  final key = data + nums.join('');

  if (cache.containsKey(key)) {
    return cache[key]!;
  }

  int result = 0;

  if (['.', '?'].contains(data[0])) {
    result += generate(data.substring(1), nums);
  }

  if (['#', '?'].contains(data[0])) {
    if (nums[0] <= data.length &&
        !data.substring(0, nums[0]).contains(".") &&
        (nums[0] == data.length || data[nums[0]] != "#")) {
      result += generate(
          data.substring(min(nums[0] + 1, data.length)), nums.sublist(1));
    }
  }

  cache[key] = result;

  return result;
}
