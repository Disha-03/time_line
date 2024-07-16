import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskTimer extends StatelessWidget {
  final int taskId;

  TaskTimer({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerService>(
      builder: (context, timerService, child) {
        return Column(
          children: [
            Text(timerService.currentTime(taskId)),
            SizedBox(height: 8,),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => timerService.start(taskId),
                  child: Text('Start'),
                ),
                SizedBox(width: 2,),

                ElevatedButton(
                  onPressed: () => timerService.stop(taskId),
                  child: Text('Stop'),
                ),
                SizedBox(width: 2,),

                ElevatedButton(
                  onPressed: () => timerService.reset(taskId),
                  child: Text('Reset'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class TimerService extends ChangeNotifier {
  final Map<int, Stopwatch> _stopwatches = {};
  final Map<int, Timer> _timers = {};

  String currentTime(int taskId) {
    final stopwatch = _stopwatches[taskId] ?? Stopwatch();
    return stopwatch.elapsed.inMinutes.toString().padLeft(2, '0') +
        ':' +
        (stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
  }

  void start(int taskId) {
    if (!_stopwatches.containsKey(taskId)) {
      _stopwatches[taskId] = Stopwatch();
    }
    final stopwatch = _stopwatches[taskId]!;
    stopwatch.start();
    _timers[taskId] = Timer.periodic(Duration(seconds: 1), (timer) {
      notifyListeners();
    });
  }

  void stop(int taskId) {
    final stopwatch = _stopwatches[taskId];
    final timer = _timers[taskId];
    if (stopwatch != null && timer != null) {
      stopwatch.stop();
      timer.cancel();
      notifyListeners();
    }
  }

  void reset(int taskId) {
    final stopwatch = _stopwatches[taskId];
    if (stopwatch != null) {
      stopwatch.reset();
      notifyListeners();
    }
  }
}
