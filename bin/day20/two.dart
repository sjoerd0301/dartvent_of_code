import 'dart:collection';
import 'dart:io';

void main() {
  final file = File('data.txt');

  final input = file.readAsLinesSync();

  final modules = Map.fromEntries(input.map((e) {
    final splits = e.split(' -> ');
    final modules = splits.last.split(', ');
    if (splits.first == 'broadcaster') {
      final module = Module.create('%', modules);
      (module as Pulse).isOn = true;
      return MapEntry(splits.first, module);
    }
    return MapEntry(splits.first.substring(1),
        Module.create(splits.first.substring(0, 1), modules));
  }));

  for (final module in modules.entries) {
    for (final output in module.value.modules) {
      if (modules[output] is Inverter) {
        (modules[output] as Inverter).inputStates[module.key] = false;
      }
    }
  }

  final module =
      modules.entries.where((e) => e.value.modules.contains('rx')).first;

  final toRX = module.key;

  final seen = (module.value as Inverter)
      .inputStates
      .map((key, value) => MapEntry(key, 0));

  final cycles = <String, int>{};

  int presses = 0;

  while (true) {
    presses++;

    Queue<(String, String, int)> Q = Queue();
    Q.add(('broadcaster', '', 0));

    while (Q.isNotEmpty) {
      final (target, origin, state) = Q.removeFirst();

      if (!modules.containsKey(target)) continue;
      final module = modules[target]!;

      if (toRX == target && state == 1) {
        seen[origin] = seen[origin]! + 1;

        if (!cycles.containsKey(origin)) {
          cycles[origin] = presses;
        }

        if (seen.values.every((element) => element > 0)) {
          int c = 1;
          for (final cycle in cycles.values) {
            c = c * cycle ~/ c.gcd(cycle);
          }

          print(c);
          return;
        }
      }

      final (nextState, modulesToUpdate) = module.updateState(state, origin);

      if (nextState != -1) {
        for (final toUpdate in modulesToUpdate) {
          Q.add((toUpdate, target, nextState));
        }
      }
    }

    (modules['broadcaster'] as Pulse).isOn = true;
  }
}

abstract class Module {
  final List<String> modules;

  Module(this.modules);

  factory Module.create(String type, List<String> modules) {
    if (type == '&') {
      return Inverter(modules);
    } else {
      return Pulse(modules);
    }
  }

  (int, List<String>) updateState(int state, String origin);
}

class Pulse extends Module {
  bool isOn = false;
  Pulse(List<String> modules) : super(modules);

  @override
  (int, List<String>) updateState(int pulse, String origin) {
    if (pulse == 1) return (-1, []);

    if (pulse == 0) isOn = !isOn;

    return (isOn ? 1 : 0, modules);
  }

  @override
  String toString() {
    return 'pulse $modules';
  }
}

class Inverter extends Module {
  bool isOn = false;
  final inputStates = <String, bool>{};
  Inverter(List<String> modules) : super(modules);

  @override
  (int, List<String>) updateState(int pulse, String origin) {
    if (inputStates.length == 1) {
      return (pulse == 1 ? 0 : 1, modules);
    }

    inputStates[origin] = pulse == 1;

    if (inputStates.values.every((e) => e == true)) {
      return (0, modules);
    }
    return (1, modules);
  }

  @override
  String toString() {
    return 'inver $modules, $inputStates';
  }
}
