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
  int _userId = 0;

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

  Future<void> loadTasksForUser(int userId) async {
    _userId = userId;
    _filter = 'all';
    _tasks = await DatabaseHelper.instance.getAllTasks(userId);
    notifyListeners();
  }

  void clearTasks() {
    _tasks = [];
    _userId = 0;
    _filter = 'all';
    _searchQuery = '';
    notifyListeners();
  }

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
      userId: _userId,
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
    final task = Task(
      id: id,
      userId: _userId,
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
    await DatabaseHelper.instance.updateTask(task);
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
      _tasks = await DatabaseHelper.instance.searchTasks(_userId, keyword);
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
        _tasks = await DatabaseHelper.instance.getTasksDueToday(_userId);
        break;
      case 'completed':
        _tasks = await DatabaseHelper.instance.getCompletedTasks(_userId);
        break;
      case 'all':
      default:
        _tasks = await DatabaseHelper.instance.getAllTasks(_userId);
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
