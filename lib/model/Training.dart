import 'package:mci_fitness_app/model/Uebung.dart';

class Training {
  final String name;
  final String description;
  final int duration;
  final String category;
  final String split;
  final List<Uebung> exercises;

  Training({
    required this.name,
    required this.description,
    required this.duration,
    required this.category,
    required this.split,
    required this.exercises,
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
