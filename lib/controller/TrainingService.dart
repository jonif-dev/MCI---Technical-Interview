import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:mci_fitness_app/model/Training.dart';
import 'package:mci_fitness_app/model/Uebung.dart';

class TrainingService {
  static Future<List<Training>> loadWorkouts() async {
    final String response =
        await rootBundle.loadString('assets/trainingsplan.json');

    final List<dynamic> data = json.decode(response);

    return data.map((json) => Training.fromJson(json)).toList();
  }

  static Future<List<Training>> loadTrainings() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print('User not logged in');
      return [];
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('trainings')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();

        return Training(
          name: data['name'],
          description: data['description'],
          split: data['split'],
          category: data['category'],
          duration: data['duration'],
          done: data['done'],
          exercises: (data['exercises'] as List).map((exercise) {
            return Uebung(
              name: exercise['name'],
              sets: exercise['sets'],
              reps: exercise['reps'],
              repUnit: exercise['repUnit'],
              weight: exercise['weight'],
              weightUnit: exercise['weightUnit'],
              breakTime: exercise['break'],
              muscleGroup: exercise['muscleGroup'],
              equipment: List<String>.from(exercise['equipment'] ?? []),
              performedSets: List<Map<String, dynamic>>.from(
                  exercise['performedSets'] ?? []),
            );
          }).toList(),
        );
      }).toList();
    } catch (e) {
      print('Fehler beim Laden der Trainings: $e');
      throw Exception('Fehler beim Laden der Trainings');
    }
  }
}
