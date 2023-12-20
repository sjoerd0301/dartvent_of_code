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

  int lo = 0, hi = 0;

  for (int i = 0; i < 1000; i++) {
    Queue<(String, String, int)> Q = Queue();
    Q.add(('broadcaster', '', 0));

    while (Q.isNotEmpty) {
      final (name, origin, state) = Q.removeFirst();

      if (state == 0) lo++;
      if (state == 1) hi++;

      if (!modules.containsKey(name)) continue;
      final module = modules[name]!;

      final (nextState, modulesToUpdate) = module.updateState(state, origin);

      if (nextState != -1) {
        for (final toUpdate in modulesToUpdate) {
          Q.add((toUpdate, name, nextState));
        }
      }
    }

    (modules['broadcaster'] as Pulse).isOn = true;
  }

  print('lo $lo, hi $hi sum ${lo * hi}');
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
