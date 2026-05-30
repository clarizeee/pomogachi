import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models.dart';

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class ProviderClass extends ChangeNotifier {
  List _tasks = [];
  List _habits = [];
  List<int> _queue = [];

  List get tasks => _tasks;
  List get habits => _habits;
  List<int> get queue => _queue;
  List get parentTasks => _tasks.where((t) => t.subtasks.isNotEmpty).toList();

  Future<void> writeQueue() async {
    await FileManager().writeQueue(_queue, "queue");
    notifyListeners();
  }

  Future<void> getTasks() async {
    List list = await FileManager().readJsonFile("data", "tasks");
    _tasks = list.map((e) => Task.fromMap(e)).toList();
    print("ur done yay");
    notifyListeners();
  }

  Future<void> getQueue() async {
    _queue = await FileManager().readQueue("queue");
    print(_queue);
    print("ur done yay");
    notifyListeners();
  }

  Future<void> addToQueue(Task task) async {
    if (_queue.contains(task.id)) {
      return;
    }
    _queue.add(task.id);
    print("ur done yay");
    await writeQueue();
  }

  Future<void> removeFromQueue(Task task) async {
    _queue.remove(task.id);
    await writeQueue();
    print("ur done yay");

    notifyListeners();
  }

  Future<void> updateQueue(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex--;
    }

    final int id = _queue.removeAt(oldIndex);
    _queue.insert(newIndex, id);
    await writeQueue();
  }

  Future<void> removeCompletes() async {
    final completedIds = _tasks
        .where((t) => t.is_Completed)
        .map((t) => t.id)
        .toSet();

    // remove from tasks
    _queue.removeWhere((id) => completedIds.contains(id));
    _tasks.removeWhere((t) => t.is_Completed);

    // remove from queue (id-based)

    notifyListeners();
    await writeQueue();
    await FileManager().writeJsonFile(_tasks, "data", "tasks");
  }

  Future<void> editTask(Task task) async {
    final index = _tasks.indexWhere((e) => e.id == task.id);
    _tasks[index] = _tasks[index].copyWith(
      id: task.id,
      name: task.name,
      category: task.category,
      deadline: task.deadline,
      subtasks: task.subtasks,
      is_Completed: task.is_Completed,
      is_Standalone: task.is_Standalone,
    );
    //TODO: write on json file
    await FileManager().writeJsonFile(_tasks, "data", "tasks");
    notifyListeners();
  }

  Future<void> toggleComplete(Task task) async {
    final index = _tasks.indexWhere((e) => e.id == task.id);

    final newValue = !_tasks[index].is_Completed;

    _tasks[index] = _tasks[index].copyWith(is_Completed: newValue);
    if (task.subtasks.isEmpty) {
      await FileManager().writeJsonFile(_tasks, "data", "tasks");
      notifyListeners();
      return;
    }

    final subtasks = task.subtasks;

    for (var id in subtasks) {
      final subindex = _tasks.indexWhere((e) => e.id == id);
      if (subindex == -1) continue;
      _tasks[subindex] = _tasks[subindex].copyWith(is_Completed: newValue);
    }
    await FileManager().writeJsonFile(_tasks, "data", "tasks");
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    print("Ok added na cya boss");
    print(task);
    await FileManager().writeJsonFile(_tasks, "data", "tasks");
    notifyListeners();
  }

  Future<void> addSubTask(Task parent_task, Task child_task) async {
    final parent_index = _tasks.indexWhere((e) => e.id == parent_task.id);

    final updatedParent = _tasks[parent_index];

    final updatedSubtasks = [...updatedParent.subtasks, child_task.id];

    _tasks[parent_index] = updatedParent.copyWith(
      is_Standalone: false,
      subtasks: updatedSubtasks,
    );

    await addTask(child_task);
  }

  Future<void> deleteTask(Task task) async {
    print("Delete trigger");
    if (_queue.contains(task.id)) {
      removeFromQueue(task);
    }
    final index = _tasks.indexWhere((e) => e.id == task.id);
    _tasks.remove(_tasks[index]);
    await FileManager().writeJsonFile(_tasks, "data", "tasks");

    notifyListeners();
  }
}

class FileManager {
  FileManager._internal();

  static final FileManager _instance = FileManager._internal();

  factory FileManager() =>
      _instance; // u call it as FileManager().<method here>

  Future<String> get _directoryPath async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _file async {
    final path = await _directoryPath;
    return File('$path/cheetah.txt');
  }

  Future<File> get_jsonFile(String fileName) async {
    final path = await _directoryPath;
    print("path found!!!");
    return File('$path/$fileName.json');
  }

  Future<List<int>> readQueue(String fileName) async {
    File file = await get_jsonFile(fileName);

    if (!await file.exists()) return [];

    final content = await file.readAsString();
    final decoded = json.decode(content);

    if (decoded is Map && decoded["queue"] is List) {
      return (decoded["queue"] as List).map((e) => e as int).toList();
    }

    return [];
  }

  Future<void> writeQueue(List<int> queue, String fileName) async {
    File file = await get_jsonFile(fileName);
    print("im writing here");
    await file.writeAsString(json.encode({"queue": queue}), flush: true);
  }

  Future<List<dynamic>> readJsonFile(String fileName, String category) async {
    File file = await get_jsonFile(fileName);

    if (!await file.exists()) {
      try {
        final assetContent = await rootBundle.loadString('data/$fileName.json');
        await file.writeAsString(assetContent);
      } catch (e) {
        print("Asset load failed: $e");
        return [];
      }
    }

    try {
      String content = await file.readAsString();

      if (content.isEmpty) return [];

      final decoded = json.decode(content);

      if (decoded is Map<String, dynamic>) {
        final data = decoded[category];

        if (data is List) {
          return data;
        }
      }

      return [];
    } catch (e) {
      print("JSON error: $e");
      return [];
    }
  }

  /*   Future<List<dynamic>> readJsonFile(String fileName, String category) async {
    try {
      final String content = await rootBundle.loadString('data/$fileName.json');

      final Map<String, dynamic> data = json.decode(content);

      final result = data[category];

      if (result is List) {
        return result;
      }

      return [];
    } catch (e) {
      print("Failed to load asset JSON: $e");
      return [];
    }
  } */

  Future<void> writeJsonFile(
    List tasksList,
    String dest,
    String category,
  ) async {
    File file = await get_jsonFile(dest);
    await file.writeAsString(
      json.encode({category: tasksList.map((h) => h.toJson()).toList()}),
      flush: true,
    );
    print("Reached here!");
    //return Tasks;
  }

  Future<File> get _imageFile async {
    final path = await _directoryPath;
    return File('$path/cheetah_image');
  }

  Future<String> readTextFile() async {
    String fileContent = 'blaaaank';

    File file = await _file;

    if (await file.exists()) {
      try {
        fileContent = await file.readAsString();
      } catch (e) {
        print(e);
      }
    }

    return fileContent;
  }

  Future<String> writeTextFile() async {
    String text = DateFormat('h:mm:ss').format(DateTime.now());

    File file = await _file;
    await file.writeAsString(text);
    return text;
  }

  Future<Uint8List> writeImageFile() async {
    Response response = await Client().get(
      Uri.parse(
        'https://i.pinimg.com/originals/f5/1d/08/f51d08be05919290355ac004cdd5c2d6.png',
      ),
    );

    Uint8List bytes = response.bodyBytes;
    File file = await _imageFile;
    await file.writeAsBytes(bytes);

    print(file.path);
    print(bytes);

    return bytes;
  }

  Future<Uint8List?> readImageFile() async {
    File file = await _imageFile;
    Uint8List byteList;

    if (await file.exists()) {
      try {
        byteList = await file.readAsBytes();
        return byteList;
      } catch (e) {
        print(e);
      }
    }

    return null;
  }

  deleteImage() async {
    File file = await _imageFile;
    if (await file.exists()) {
      await file.delete();
    }
  }
}

class TimerProvider extends ChangeNotifier {
  ProviderClass? _provider;

  Timer? _timer;

  int _start = 1500;
  int _initial = 1500;
  bool _isRunning = false;

  int get start => _start;
  int get initial => _initial;
  bool get isRunning => _isRunning;
  bool _finishing = false;
  PomodoroMode _mode = workMode;

  PomodoroMode get mode => _mode;

  PomodoroController? _controller;

  void attachProvider(ProviderClass provider) {
    _provider = provider;
  }

  Map<int, Task> get taskMap => {
    for (var t in _provider?.tasks ?? <Task>[]) t.id: t,
  };

  List<Task> get queuedTasks => (_provider?.queue ?? [])
      .map((id) => taskMap[id])
      .whereType<Task>()
      .toList();

  void setTimer(int seconds) {
    _timer?.cancel();
    _start = seconds;
    _initial = seconds;
    notifyListeners();
  }

  Task? _currentTask;

  Task? get currentTask => _currentTask;

  void setMode(PomodoroMode mode) {
    clearTask();
    //_timer?.cancel();

    _mode = mode;
    _start = mode.duration;
    _initial = mode.duration;
    _isRunning = false;

    //startTimer();

    notifyListeners();
  }

  void changeTask(Task task) {
    setMode(workMode);
    _currentTask = task;
    
    // resetTimer();
    notifyListeners();
  }

  void clearTask() {
    _currentTask = null;
    _finishTimer();
    resetTimer();
    notifyListeners();
  }

  void startTimer() {
    print(_mode);
    if (_isRunning) return;

    _isRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        timer.cancel();
        //_finishTimer();
        resetTimer();
        _finishTimer();
        notifyListeners();
        return;
      }

      _start--;
      notifyListeners();
    });
  }

  void _finishTimer() async {
    if (_finishing) return; // 🔒 prevents spam
    _finishing = true;

    _timer?.cancel();
    _isRunning = false;

    if (_mode == workMode) {
      setMode(restMode);
    } else {
      if (_provider!.queue.isNotEmpty) {
        setMode(workMode);
        changeTask(queuedTasks[0]);
      }
    }

    _finishing = false;

    notifyListeners();
  }

  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    //clearTask();
    _start = _mode.duration;
    _initial = _mode.duration;
    _isRunning = false;
    notifyListeners();
  }
}

//TODO: u modify them here. im so sorry for the janky architecture................

//300

const workMode = PomodoroMode(
  name: "Work",
  duration: 1500,
  image:
      "assets/work.gif",
);

const restMode = PomodoroMode(
  name: "Rest",
  duration: 300,
  image:
      "assets/break.gif",
);

const longBreakMode = PomodoroMode(
  name: "Long Break",
  duration: 900,
  image:
      "assets/longbreak.gif",
);

class PomodoroController {
  final ProviderClass provider;
  final TimerProvider timer;

  PomodoroController({required this.provider, required this.timer});

  /// CALL THIS when timer finishes work mode
  Future<void> onWorkComplete() async {
    if (timer.currentTask == null) {
      return;
    }
    print("on work complete running!");
    if (provider.queue.isEmpty) return;

    timer.setMode(restMode);
    timer.startTimer();
  }

  /// CALL THIS when break finishes
  void onBreakComplete() {
    timer.setMode(workMode);
    //  timer.startTimer();

    _syncNextTask();
  }

  /// keeps timer task aligned with queue
  void _syncNextTask() {
    while (provider.queue.isNotEmpty) {
      final id = provider.queue.first;

      final task = provider.tasks
          .where((t) => t.id == id)
          .cast<Task?>()
          .firstOrNull;

      if (task == null) {
        provider.queue.removeAt(0);
        continue; // safe iteration instead of recursion
      }

      timer.changeTask(task);
      timer.startTimer();
      return;
    }

    timer.clearTask();
  }

  /// optional manual advance (skip task)
  Future<void> skipTask() async {
    if (provider.queue.isEmpty) return;

    provider.queue.removeAt(0);
    await provider.writeQueue();

    _syncNextTask();
  }
}

class QueueItem {
  final int taskId;
  final int modeId;

  QueueItem({required this.taskId, required this.modeId});

  factory QueueItem.fromMap(Map<String, dynamic> map) {
    return QueueItem(taskId: map['taskId'], modeId: map['modeId']);
  }

  Map<String, dynamic> toJson() => {"taskId": taskId, "modeId": modeId};
}
