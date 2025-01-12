import 'package:mci_fitness_app/model/Uebung.dart';

class Training {
  String name;
  String description;
  int duration;
  String category;
  String split;
  List<Uebung> exercises;

  bool done;
  int currentExerciseIndex;
  int currentSet;

  Training({
    required this.name,
    required this.description,
    required this.duration,
    required this.category,
    required this.split,
    required this.exercises,
    this.done = false,
    this.currentExerciseIndex = 0,
    this.currentSet = 0,
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      name: json['name'],
      description: json['description'],
      duration: json['duration'],
      category: json['category'],
      split: json['split'],
      exercises:
          (json['exercises'] as List).map((e) => Uebung.fromJson(e)).toList(),
    );
  }
}
