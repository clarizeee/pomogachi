import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pomogachi/handlers.dart';
import 'package:provider/provider.dart';
import 'package:pomogachi/models.dart';
class MyTimerWidget extends StatefulWidget {
  const MyTimerWidget({super.key});
  @override
  _MyTimerWidgetState createState() => _MyTimerWidgetState();
}

class _MyTimerWidgetState extends State<MyTimerWidget> {
  Timer? _timer;
  int  _start = 1500;
  late Task task;
  


  void startTimer() {
      _timer?.cancel();

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_start <= 0) {
          timer.cancel();
          return;
        }

        setState(() {
          _start--;
        });
      });
    }

        String format(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

@override
  
  Widget build(BuildContext context) {
    final timer = context.watch<TimerProvider>();
    final pomo = context.watch<TimerProvider>().mode;
    String modename = pomo.name;
    return Column(
      spacing: 10,
      children: [
        SizedBox(
          height: 200,
          child: CircularPercentIndicator(
            radius: 100.0,
            lineWidth: 10.0,
          
            percent: timer.start / timer.initial, // dynamic progress
            center: CircleAvatar(
              radius: 100-10,
              backgroundImage: NetworkImage(timer.isRunning == true ? timer.mode.image : "https://media.tenor.com/h2TRPv-yfBQAAAAM/gayixiangs.gif"), //TODO : "idle image" the else here is actually the "idle" phase. its also hardcoded im so so sorry
            ),
            progressColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          format(timer.start), style: Theme.of(context).textTheme.headlineLarge
        ),
        (timer.isRunning == false) ?
        Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
          children: [

            ElevatedButton(onPressed: () {
              context.read<TimerProvider>().startTimer();
            }, child: const Text("Start Timer")),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TimerProvider>().clearTask();
                      context.read<TimerProvider>().resetTimer();
                    },
                    child: const Text("Reset Timer")),            
          ],

        ) : 
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<TimerProvider>().pauseTimer();
                    },
                    child: const Text("Pause Timer"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TimerProvider>().resetTimer();
                      
                    },
                    child: const Text("Reset Timer"),
                  )             
        ],),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const PomodoroSettingsDialog(
                modes: [],
              ),
            );
          },
          child: Text(modename),
        ),
      ],
    );
  }
}


class PomodoroSettingsDialog extends StatelessWidget {
  final List<PomodoroMode> modes;

  const PomodoroSettingsDialog({super.key, required this.modes});

  @override
  Widget build(BuildContext context) {
    final timer = context.read<TimerProvider>();

    return AlertDialog(
      title: const Text("Select Mode"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: modes.map((mode) {
          return ListTile(
            title: Text(mode.name),
            onTap: () {
              timer.setMode(mode);
              timer.startTimer();
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}
