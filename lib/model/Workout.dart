import 'package:mci_fitness_app/model/Uebung.dart';

// Die Klasse Workout repräsentiert ein gesamtes Workout (Trainingseinheit)
class Workout {
  String name; // Der Name des Workouts (z.B. "Beintraining")
  String description; // Eine kurze Beschreibung des Workouts
  int duration; // Die Dauer des Workouts in Minuten
  String
      category; // Die Kategorie des Workouts (z.B. "Krafttraining", "Ausdauer")
  String
      split; // Der Trainingssplit (z.B. "Ganzkörper", "Oberkörper/Unterkörper")
  List<Uebung>
      exercises; // Eine Liste der Übungen, die dieses Workout beinhalten

  // Konstruktor zum Initialisieren eines Workout-Objekts mit den oben genannten Parametern
  Workout({
    required this.name,
    required this.description,
    required this.duration,
    required this.category,
    required this.split,
    required this.exercises, // Liste von Übungen, die im Workout enthalten sind
  });

  // Factory-Methode zum Erstellen eines Workout-Objekts aus einer JSON-Struktur
  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      name: json['name'], // Der Name des Workouts
      description: json['description'], // Die Beschreibung des Workouts
      duration: json['duration'], // Die Dauer des Workouts
      category: json['category'], // Die Kategorie des Workouts
      split: json['split'], // Der Split des Workouts (z.B. "Ganzkörper")
      exercises: (json['exercises']
              as List) // Extrahiert die Liste der Übungen aus dem JSON
          .map((e) => Uebung.fromJson(
              e)) // Wandelt jedes Element in ein Uebung-Objekt um
          .toList(), // Gibt die Liste der Übungen zurück
    );
  }
}
