// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Task {
  int id;
  String name;
  String category;
  String deadline;
  List subtasks;
  bool is_Completed;
  bool is_Standalone;

  Task({
    required this.id,
    required this.name,
    required this.category,
    required this.deadline,
    required this.subtasks,
    required this.is_Completed,
    required this.is_Standalone,
  });


  Task copyWith({
    int? id,
    String? name,
    String? category,
    String? deadline,
    List? subtasks,
    bool? is_Completed,
    bool? is_Standalone,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      deadline: deadline ?? this.deadline,
      subtasks: subtasks ?? this.subtasks,
      is_Completed: is_Completed ?? this.is_Completed,
      is_Standalone: is_Standalone ?? this.is_Standalone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'category': category,
      'deadline': deadline,
      'subtasks': subtasks,
      'is_Completed': is_Completed,
      'is_Standalone': is_Standalone,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int,
      name: map['name'] as String,
      category: map['category'] as String,
      deadline: map['deadline'] as String,
      subtasks: List.from((map['subtasks'] as List)),
      is_Completed: map['is_Completed'] as bool,
      is_Standalone: map['is_Standalone'] as bool,
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Task(id: $id, name: $name, category: $category, deadline: $deadline, subtasks: $subtasks, is_Completed: $is_Completed, is_Standalone: $is_Standalone)';
  }

  @override
  bool operator ==(covariant Task other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.category == category &&
      other.deadline == deadline &&
      listEquals(other.subtasks, subtasks) &&
      other.is_Completed == is_Completed &&
      other.is_Standalone == is_Standalone;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      category.hashCode ^
      deadline.hashCode ^
      subtasks.hashCode ^
      is_Completed.hashCode ^
      is_Standalone.hashCode;
  }
}

class PomodoroMode {
  final String name;
  final int duration;
  final String image;

  const PomodoroMode({
    required this.name,
    required this.duration,
    required this.image,
  });

  PomodoroMode copyWith({
    String? name,
    int? duration,
    String? image,
  }) {
    return PomodoroMode(
      name: name ?? this.name,
      duration: duration ?? this.duration,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'duration': duration,
      'image': image,
    };
  }

  factory PomodoroMode.fromMap(Map<String, dynamic> map) {
    return PomodoroMode(
      name: map['name'] as String,
      duration: map['duration'] as int,
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PomodoroMode.fromJson(String source) => PomodoroMode.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PomodoroMode(name: $name, duration: $duration, image: $image)';

  @override
  bool operator ==(covariant PomodoroMode other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.duration == duration &&
      other.image == image;
  }

  @override
  int get hashCode => name.hashCode ^ duration.hashCode ^ image.hashCode;
}
