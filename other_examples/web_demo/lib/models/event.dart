import 'package:flutter/material.dart';

//todo k: modify this to better fit firebase
//todo k: do a function that hardcodes a color 4 an assigned consultorio
class Event {
  Event({
    required this.title,
    this.description,
    this.color,
  });

  /// The title of the [Event].
  final String title;

  /// The description of the [Event].
  final String? description;

  /// The color of the [Event] tile.
  final Color? color;

  Event copyWith({
    String? title,
    String? description,
    Color? color,
  }) {
    return Event(
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
    );
  }

  @override
  String toString() {
    return 'title: $title, description: $description, color: ${color.toString()}';
  }
}
