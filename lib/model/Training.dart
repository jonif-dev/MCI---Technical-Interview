import 'package:mci_fitness_app/model/Workout.dart';

class Training {
  String? id;
  Workout workout;
  bool done;
  int currentExerciseIndex;
  int currentSet;
  DateTime? lastSave;

  Training({
    this.id,
    required this.workout,
    this.done = false,
    this.currentExerciseIndex = 0,
    this.currentSet = 0,
    this.lastSave,
  });

  // factory Training.fromJson(Map<String, dynamic> json) {
  //   return Training(
  //     name: json['name'],
  //     description: json['description'],
  //     duration: json['duration'],
  //     category: json['category'],
  //     split: json['split'],
  //     exercises:
  //         (json['exercises'] as List).map((e) => Uebung.fromJson(e)).toList(),
  //   );
  // }
}
