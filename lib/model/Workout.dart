import 'package:mci_fitness_app/model/Uebung.dart';

class Workout {
  String name;
  String description;
  int duration;
  String category;
  String split;
  List<Uebung> exercises;

  Workout({
    required this.name,
    required this.description,
    required this.duration,
    required this.category,
    required this.split,
    required this.exercises,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
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
