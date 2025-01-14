import 'package:mci_fitness_app/model/Workout.dart';

// Diese Klasse repräsentiert ein Training
class Training {
  String? id; // Eindeutige ID für das Training
  Workout workout; // Zugehöriges Workout
  bool done; // Gibt an, ob das Training abgeschlossen wurde
  int currentExerciseIndex; // Index der aktuellen Übung im Workout
  int currentSet; // Aktueller Satz der aktuellen Übung
  DateTime? lastSave; // Letzter Zeitpunkt der Speicherung

  // Konstruktor für die Training-Klasse
  Training({
    this.id,
    required this.workout,
    this.done = false,
    this.currentExerciseIndex = 0,
    this.currentSet = 0,
    this.lastSave,
  });
}
