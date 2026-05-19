// creating a Task class to represent the data structure of a task in the app
class Task {
  final int? id;
  final int userId;
  final String title;
  final String description;
  final String priority;
  final DateTime? deadline;
  final List<String> modules;
  final bool reminders;
  final bool isComplete;
  final DateTime createdAt;

  Task({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.priority,
    required this.deadline,
    required this.modules,
    required this.reminders,
    required this.isComplete,
    required this.createdAt,
  });

  // this converts Task object to a Map which SQLite understands
  Map<String, dynamic> toMap() {
    return {
      'id':          id,
      'userId':      userId,
      'title':       title,
      'description': description,
      'priority':    priority,
      // DateTime stored as ISO string SQLite has no date type
      'deadline':    deadline?.toIso8601String(),
      'modules':     modules.join(','),
      // bool stored as 1 or 0 SQLite has no boolean type
      'reminders':   reminders ? 1 : 0,
      'isComplete':  isComplete ? 1 : 0,
      'createdAt':   createdAt.toIso8601String(),
    };
  }

  //  rebuilds a Task object from a SQLite row 
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id:          map['id'] as int?,
      userId:      map['userId'] as int,
      title:       map['title'] as String,
      description: map['description'] as String,
      priority:    map['priority'] as String,
      // parse ISO string back to DateTime
      deadline:    map['deadline'] != null
                    ? DateTime.parse(map['deadline'] as String)
                    : null,
      // split comma string back into a List and removwe any empty strings
      modules:     (map['modules'] as String)
                    .split(',')
                    .where((m) => m.isNotEmpty)
                    .toList(),
      reminders:   (map['reminders'] as int) == 1,
      isComplete:  (map['isComplete'] as int) == 1,
      createdAt:   DateTime.parse(map['createdAt'] as String),
    );
  }

  // this creates a copy of the task with updated fields 
  // used by the controller when editing a task
  Task copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    String? priority,
    DateTime? deadline,
    List<String>? modules,
    bool? reminders,
    bool? isComplete,
    DateTime? createdAt,
  }) {
    return Task(
      id:          id          ?? this.id,
      userId:      userId      ?? this.userId,
      title:       title       ?? this.title,
      description: description ?? this.description,
      priority:    priority    ?? this.priority,
      deadline:    deadline    ?? this.deadline,
      modules:     modules     ?? this.modules,
      reminders:   reminders   ?? this.reminders,
      isComplete:  isComplete  ?? this.isComplete,
      createdAt:   createdAt   ?? this.createdAt,
    );
  }
}