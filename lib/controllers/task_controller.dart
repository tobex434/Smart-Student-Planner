import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/database_helper.dart';

class TaskController extends ChangeNotifier {
  // private task list screens read via getter but never directly
  List<Task> _tasks = [];

  // current search keyword
  String _searchQuery = '';

  // current filter: 'all', 'today', 'completed'
  String _filter = 'all';

  // public getters screens read these, never _tasks directly
  List<Task> get tasks => _tasks;
  String get searchQuery => _searchQuery;
  String get filter => _filter;

  // derived counts dashboard stats read these
  int get totalCount => _tasks.length;

  int get completedCount => _tasks.where((t) => t.isComplete).length;

  int get dueTodayCount {
    final today = DateTime.now();
    return _tasks.where((t) {
      if (t.deadline == null) return false;
      return t.deadline!.year == today.year &&
          t.deadline!.month == today.month &&
          t.deadline!.day == today.day &&
          !t.isComplete;
    }).length;
  }

  // called once when the app starts loads all tasks from SQLite
  Future<void> loadTasks() async {
    _tasks = await DatabaseHelper.instance.getAllTasks();
    notifyListeners();
  }

  // CREATE

  Future<void> addTask({
    required String title,
    required String description,
    required String priority,
    required DateTime? deadline,
    required List<String> modules,
    required bool reminders,
  }) async {
    // build the Task object
    final task = Task(
      title: title,
      description: description,
      priority: priority,
      deadline: deadline,
      modules: modules,
      reminders: reminders,
      isComplete: false,
      // controller adds createdAt the form does not know about this
      createdAt: DateTime.now(),
    );

    // save to SQLite
    await DatabaseHelper.instance.insertTask(task);

    // reload fresh list from SQLite + notify screens
    await _reload();
  }

  // UPDATE

  Future<void> updateTask({
    required int id,
    required String title,
    required String description,
    required String priority,
    required DateTime? deadline,
    required List<String> modules,
    required bool reminders,
    required bool isComplete,
    required DateTime createdAt,
  }) async {
    final updatedTask = Task(
      // same id SQLite finds the right row to overwrite
      id: id,
      title: title,
      description: description,
      priority: priority,
      deadline: deadline,
      modules: modules,
      reminders: reminders,
      isComplete: isComplete,
      // keep original createdAt do not reset it on edit
      createdAt: createdAt,
    );

    await DatabaseHelper.instance.updateTask(updatedTask);
    await _reload();
  }

  // flips isComplete true/false for a single task
  Future<void> toggleComplete(Task task) async {
    await DatabaseHelper.instance.toggleComplete(task.id!, !task.isComplete);
    await _reload();
  }

  // DELETE

  Future<void> deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    await _reload();
  }

  // SEARCH

  // called every time the user types in the search bar
  Future<void> setSearch(String keyword) async {
    _searchQuery = keyword;

    if (keyword.trim().isEmpty) {
      // empty search load everything
      await _reload();
    } else {
      // search SQLite for matching tasks
      _tasks = await DatabaseHelper.instance.searchTasks(keyword);
      notifyListeners();
    }
  }

  // clears the search and reloads all tasks
  Future<void> clearSearch() async {
    _searchQuery = '';
    await _reload();
  }

  // FILTER

  // called when user taps a filter chip
  Future<void> setFilter(String filter) async {
    _filter = filter;

    switch (filter) {
      case 'today':
        _tasks = await DatabaseHelper.instance.getTasksDueToday();
        break;
      case 'completed':
        _tasks = await DatabaseHelper.instance.getCompletedTasks();
        break;
      case 'all':
      default:
        _tasks = await DatabaseHelper.instance.getAllTasks();
        break;
    }

    notifyListeners();
  }

  // PRIVATE HELPERS

  // reloads task list respecting the current filter
  // called after every add, update, delete, toggle
  Future<void> _reload() async {
    await setFilter(_filter);
  }
}
