import 'dart:io';

import 'package:collection/collection.dart';

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

  final parts =
      input.last.replaceAll('{', '').replaceAll('}', '').split('\n').map((e) {
    final splits =
        e.split(',').map((e) => (int.parse(e.split('=').last))).toList();

    return (splits[0], splits[1], splits[2], splits[3]);
  });

  final start = 'in';

  final accepted = <(int, int, int, int)>[];

  for (final part in parts) {
    var cur = start;
    while (true) {
      if (cur == 'A') {
        accepted.add(part);
        break;
      }
      if (cur == 'R') break;

      String redir = '';
      print(cur);
      final (rules, fb) = workflows[cur]!;

      for (final rule in rules) {
        final (c, op, q, r) = rule;

        final toCheck = switch (c) {
          'x' => part.$1,
          'm' => part.$2,
          'a' => part.$3,
          's' => part.$4,
          _ => throw Exception('ERROR')
        };

        if (op == '<' && toCheck < q) {
          redir = r;
          break;
        } else if (op == '>' && toCheck > q) {
          redir = r;
          break;
        }
      }

      if (redir == '') {
        cur = fb;
      } else if (redir == 'A') {
        accepted.add(part);
        break;
      } else if (redir == 'R') {
        break;
      } else {
        cur = redir;
      }
    }
  }

  print(accepted.map((e) => e.$1 + e.$2 + e.$3 + e.$4).sum);
}
