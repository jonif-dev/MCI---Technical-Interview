import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:mci_fitness_app/model/Training.dart';
import 'package:mci_fitness_app/model/Uebung.dart';
import 'package:mci_fitness_app/model/Workout.dart';

class TrainingService {
  // Lädt Workouts aus einer lokalen JSON-Datei
  static Future<List<Workout>> loadWorkouts() async {
    final String response = await rootBundle
        .loadString('assets/trainingsplan.json'); // Liest die JSON-Datei
    final List<dynamic> data =
        json.decode(response); // Dekodiert die JSON-Daten
    return data
        .map((json) => Workout.fromJson(json))
        .toList(); // Konvertiert zu Workout-Objekten
  }

  // Lädt Trainings eines Benutzers aus Firestore
  static Future<List<Training>> loadTrainings() async {
    final userId = FirebaseAuth.instance.currentUser
        ?.uid; // Holt die User-ID des aktuell angemeldeten Benutzers

    print(userId);
    if (userId == null) {
      print(
          'User not logged in'); // Fehlermeldung, wenn kein Benutzer angemeldet ist
      return [];
    }
    try {
      // Holt die Trainings-Daten des Benutzers aus Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('trainings')
          .orderBy('lastSave', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Training(
            id: doc.id, // Setzt die Trainings-ID
            done: data['done'], // Status des Trainings
            lastSave:
                data['lastSave'].toDate(), // Datum der letzten Speicherung
            currentExerciseIndex:
                data['currentExerciseIndex'], // Aktuelle Übung
            currentSet: data['currentSet'], // Aktueller Satz
            workout: Workout(
              name: data['workout']['name'], // Name des Workouts
              description: data['workout']['description'], // Beschreibung
              split: data['workout']['split'], // Split (z. B. Push, Pull)
              category: data['workout']['category'], // Kategorie
              duration: data['workout']['duration'], // Dauer des Workouts
              exercises: (data['workout']['exercises'] as List).map((exercise) {
                return Uebung(
                  name: exercise['name'], // Name der Übung
                  sets: exercise['sets'], // Anzahl der Sätze
                  reps: exercise['reps'], // Wiederholungen
                  repUnit: exercise['repUnit'], // Einheit der Wiederholungen
                  weight: exercise['weight'], // Gewicht
                  weightUnit: exercise['weightUnit'], // Gewichtseinheit
                  breakTime: exercise['break'], // Pausenzeit
                  muscleGroup: exercise['muscleGroup'], // Muskelgruppe
                  equipment: List<String>.from(
                      exercise['equipment'] ?? []), // Ausrüstung
                  performedSets: List<Map<String, dynamic>>.from(
                      exercise['performedSets'] ?? []), // Durchgeführte Sätze
                );
              }).toList(),
            ));
      }).toList();
    } catch (e) {
      // Fehlerbehandlung bei Firestore-Zugriff
      print('Fehler beim Laden der Trainings: $e');
      throw Exception('Fehler beim Laden der Trainings');
    }
  }
}
