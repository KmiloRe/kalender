import 'package:flutter/material.dart';

//todo k: modify this to better fit firebase
//todo k: do a function that hardcodes a color 4 an assigned consultorio

enum Consultorio {
  consultorio_1(
    title: "Consultorio 1",
    content: "",
    color: Colors.red,
  ),
  consultorio_2(
    title: "Consultorio 2",
    content: "",
    color: Colors.green,
  ),
  consultorio_3(
    title: "Consultorio 3",
    content: "",
    color: Colors.blue,
  ),
  consultorio_4(
    title: "Consultorio 4",
    content: "",
    color: Colors.orange,
  ),
  consultorio_5(
    title: "Consultorio 5",
    content: "",
    color: Colors.purple,
  ),
  consultorio_6(
    title: "Consultorio 6",
    content: "",
    color: Colors.yellow,
  ),
  consultorio_7(
    title: "Consultorio 7",
    content: "",
    color: Colors.pink,
  ),
  consultorio_8(
    title: "Consultorio 8",
    content: "",
    color: Colors.teal,
  ),
  consultorio_9(
    title: "Consultorio 9",
    content: "",
    color: Colors.brown,
  ),
  consultorio_10(
    title: "Consultorio 10",
    content: "",
    color: Colors.grey,
  ),
  consultorio_11(
    title: "Consultorio 11",
    content: "",
    color: Colors.cyan,
  ),
  consultorio_12(
    title: "Consultorio 12",
    content: "",
    color: Colors.lime,
  ),
  administracion(
    title: "Administración",
    content: "",
    color: Colors.indigo,
  ),
  ninguno(
    title: "Ninguno",
    content: "No se ha asignado un consultorio",
    color: Colors.greenAccent,
  );

  final String content;
  final String title;
  final Color color;
  const Consultorio({
    required this.content,
    required this.title,
    required this.color,
  });

  factory Consultorio.fromTitle(String title) {
    return Consultorio.values.firstWhere(
      (element) => element.title == title,
      orElse: () => Consultorio.ninguno,
    );
  }
}

String getColorFromConsultorio(String consultorio) {
  return Consultorio.fromTitle(consultorio).color.toString();
}

//todo k: make required fields
//todo k: add paciente, profesional, consultorio, etc
class Event {
  Event({
    required this.title,
    this.description,
    // this.color,
    this.consultorio,
    //todo k: profesional should be a user id or a user object
    this.profesional,
  });

  /// The title of the [Event].
  final String title;

  /// The description of the [Event].
  final String? description;

  /// The color of the [Event] tile.
  // final Color? color;

  final Consultorio? consultorio;

  final String? profesional;

  Event copyWith({
    String? title,
    String? description,
    //Color? color,
    Consultorio? consultorio,
    String? profesional,
  }) {
    return Event(
      title: title ?? this.title,
      description: description ?? this.description,
      //color: color ?? this.color,
      consultorio: consultorio ?? this.consultorio,
      profesional: profesional ?? this.profesional,
    );
  }

  @override
  String toString() {
    return 'title: $title, description: $description, color: ${consultorio!.color.toString()}, consultorio: ${consultorio.toString()}';
  }
}
