import 'dart:io';

void main() {
  final file = File('data.txt');

  final input = file.readAsStringSync().split('\n\n');

  final workflows = Map.fromEntries(
      input.first.replaceAll('{', ' ').replaceAll('}', '').split('\n').map((e) {
    final wf = e.split(' ');
    final rules = wf.last.split(',');

    final parsed = rules.sublist(0, rules.length - 1).map((e) {
      String c, op, r;
      int q;

      if (e.contains('<')) {
        var splits = e.split(':');

        r = splits.last;
        splits = splits.first.split('<');
        c = splits.first;
        op = '<';
        q = int.parse(splits.last);
      } else {
        var splits = e.split(':');

        r = splits.last;
        splits = splits.first.split('>');
        c = splits.first;
        op = '>';
        q = int.parse(splits.last);
      }

      return (c, op, q, r);
    }).toList();

    return MapEntry(wf.first, (parsed, rules.last));
  }));

  print(count({'x': (1, 4000), 'm': (1, 4000), 'a': (1, 4000), 's': (1, 4000)},
      'in', workflows));
}

int count(Map<String, (int, int)> ranges, String cur,
    Map<String, (List<(String, String, int, String)>, String)> workflows) {
  if (cur == "R") {
    return 0;
  }

  if (cur == "A") {
    int rv = 1;
    for (final (lo, hi) in ranges.values) {
      rv *= hi - lo + 1;
    }
    return rv;
  }

  final (rules, fallback) = workflows[cur]!;

  int total = 0;

  for (final (key, cmp, n, next) in rules) {
    final (lo, hi) = ranges[key]!;

    (int, int) to, from;
    if (cmp == "<") {
      to = (lo, n - 1);
      from = (n, hi);
    } else {
      to = (n + 1, hi);
      from = (lo, n);
    }

    if (to.$1 <= to.$2) {
      Map<String, (int, int)> copy = Map.from(ranges);
      copy[key] = to;
      total += count(copy, next, workflows);
    }

    if (from.$1 <= from.$2) {
      ranges[key] = from;
    } else {
      break;
    }
  }

  total += count(Map.from(ranges), fallback, workflows);

  return total;
}
