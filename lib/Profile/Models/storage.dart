import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Task {
  String title;
  String description;
  String status;

  Task(
      {required this.title,
      required this.description,
      this.status = "pending"});

  Task.fromJson(Map json)
      : this(
            title: json['eventName']! as String,
            description: json['venue'] as String,
            status: json['status'] as String);

  Map<String, Object> toJson() {
    return {'title': title, 'description': description, 'status': status};
  }
}

class Store extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final List<Task> _taskList = [];

  get taskList {
    return _taskList;
  }

  Future<void> fetchTasks() async {
    final SharedPreferences prefs = await _prefs;
    _taskList.clear();
    String? v = prefs.getString("tasks");
    //var v1 = v?.substring(1,v.length-1).split(",");
    print("value of sharedprefernces is $v");
    var v1 = json.decode(v!);
    print("value   KAERGTGTYV is $v1");

    for (int i = 0; v1 != null && i < v1.length; i++) {
      _taskList.add(Task(
          title: v1[i]["title"],
          description: v1[i]["description"],
          status: v1[i]["status"]));
    }
    notifyListeners();
  }

  completeTask(index) async {
    Task t = _taskList[index];
    t.status = "completed";
    _taskList[index] = t;
    final SharedPreferences prefs = await _prefs;
    var v = json.encode(_taskList);
    print(v);
    await prefs.setString("tasks", v);
  }

  pendingTask(index) async {
    Task t = _taskList[index];
    t.status = "pending";
    _taskList[index] = t;
    final SharedPreferences prefs = await _prefs;
    var v = json.encode(_taskList);
    print(v);
    await prefs.setString("tasks", v);
  }

  Future<void> add(Task t) async {
    try {
      final SharedPreferences prefs = await _prefs;

      _taskList.add(t);

      var v = json.encode(_taskList);
      print(v);
      await prefs.setString("tasks", v);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> remove(int index) async {
    try {
      _taskList.removeAt(index);
      final SharedPreferences prefs = await _prefs;
      var v = json.encode(_taskList);
      print(v);
      await prefs.setString("tasks", v);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
