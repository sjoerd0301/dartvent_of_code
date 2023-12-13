import 'dart:io';
import 'package:collection/collection.dart';
import 'dart:math';

void main() {
  final file = File('data.txt');

  final input = file.readAsLinesSync();

  final data = input.map((e) {
    final splits = e.split(' ');
    return (splits[0], splits[1].split(',').map((e) => int.parse(e)).toList());
  });

  print(data.map((e) => generate(e.$1, e.$2)).sum);
}

int generate(String data, List<int> nums) {
  if (data == "") {
    return nums.isEmpty ? 1 : 0;
  }

  if (nums.isEmpty) {
    return data.contains("#") ? 0 : 1;
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

  return result;
}
