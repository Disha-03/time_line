

class Task {
  final int? id;
  final String title;
  final String description;
  final String status;
  final int timeSpent;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.timeSpent,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'timeSpent': timeSpent,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      status: map['status'],
      timeSpent: map['timeSpent'],
    );
  }
}

class Comment {
  final int? id;
  final int taskId;
  final String text;
  final DateTime timestamp;

  Comment({
    this.id,
    required this.taskId,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      taskId: map['taskId'],
      text: map['text'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}

