import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mci_fitness_app/controller/AuthController.dart';
import 'package:mci_fitness_app/model/Training.dart';
import 'package:mci_fitness_app/model/Uebung.dart';
import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class TrainingController extends GetxController {
  Training training;
  var currentExerciseIndex = 0.obs;
  var currentSet = 1.obs;
  var isBreak = false.obs;
  var timerDuration = 0.obs;
  var lastE1RM = 0.0.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? userId =
      FirebaseAuth.instance.currentUser?.uid; // Hole die userId

  TrainingController(this.training);

  Uebung get currentExercise => training.exercises[currentExerciseIndex.value];

  @override
  void onReady() {
    super.onReady();
    checkForSavedTraining();
  }

  @override
  void onClose() {
    // Wenn die Seite geschlossen wird, zurücksetzen des Zustands
    currentSet.value = 1;
    currentExerciseIndex.value = 0;
    isBreak.value = false;

    super.onClose();
  }

  void saveSet(double weight, int reps) {
    currentExercise.performedSets ??= [];
    currentExercise.performedSets?.add({
      "set": currentSet.value,
      "weight": weight,
      "reps": reps,
    });

    // e1RM für den letzten Satz berechnen
    lastE1RM.value = calculateE1RM(weight, reps);

    startBreak();
  }

  void startBreak() {
    isBreak.value = true;
    timerDuration.value = currentExercise.breakTime;

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerDuration.value > 1) {
        timerDuration.value -= 1; // Countdown aktualisieren
      } else {
        timer.cancel(); // Timer stoppen, wenn Zeit abgelaufen ist
        isBreak.value = false;

        if (currentSet.value < currentExercise.sets) {
          currentSet.value++;
        } else if (currentExerciseIndex.value < training.exercises.length - 1) {
          currentExerciseIndex.value++;
          currentSet.value = 1;
        } else {
          finishTraining(training);
        }
      }
    });
  }

  double calculateE1RM(double weight, int reps) {
    if (reps == 0) return 0; // Verhindert Division durch 0
    return weight / (0.522 + 0.419 * exp(-0.055 * reps));
  }

  // Diese Funktion speichert das aktuelle Training in Firestore
  Future<void> saveTrainingProgress() async {
    Map<String, dynamic> trainingData = {
      "name": training.name,
      "category": training.category,
      "done": false,
      "description": training.description,
      "duration": training.duration,
      "split": training.split,
      "exercises": List<Map<String, dynamic>>.from(
        training.exercises.map((exercise) {
          return {
            "name": exercise.name,
            "sets": exercise.sets,
            "reps": exercise.reps,
            "repUnit": exercise.repUnit,
            "weight": exercise.weight,
            "weightUnit": exercise.weightUnit,
            "break": exercise.breakTime,
            "muscleGroup": exercise.muscleGroup,
            "equipment": exercise.equipment,
            "performedSets": exercise.performedSets ??
                [], // Gespeicherte Daten für diese Übung
          };
        }),
      ),
      "currentExerciseIndex": currentExerciseIndex.value,
      "currentSet": currentSet.value,
    };

    // Speichert das Training im Firestore
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('trainings')
        .doc(training.name) // TrainingID könnte z.B. der Trainingsname sein
        .set(trainingData);

    print("Training progress saved to Firestore!");
  }

  void saveCompletedTraining(Training training) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print('User not logged in');
      return;
    }

    final doneTraining = {
      "name": training.name,
      "description": training.description,
      "duration": training.duration,
      "split": training.split,
      "done": true,
      "exercises": training.exercises.map((exercise) {
        return {
          "name": exercise.name,
          "sets": exercise.sets,
          "reps": exercise.reps,
          "repUnit": exercise.repUnit,
          "weight": exercise.weight,
          "weightUnit": exercise.weightUnit,
          "break": exercise.breakTime,
          "muscleGroup": exercise.muscleGroup,
          "equipment": exercise.equipment,
          "performedSets": exercise.performedSets ??
              [], // Gespeicherte Daten für diese Übung
        };
      }).toList(),
      "currentExerciseIndex": currentExerciseIndex.value,
      "currentSet": currentSet.value,
    };

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('trainings')
          .doc(training.name) // TrainingID könnte z.B. der Trainingsname sein
          .set(doneTraining);
      print('Completed training saved successfully');
    } catch (e) {
      print('Error saving completed training: $e');
    }
  }

  // Diese Funktion lädt den gespeicherten Trainingsfortschritt, falls vorhanden
  Future<void> loadTrainingProgress() async {
    DocumentSnapshot snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('trainings')
        .doc(training.name) // TrainingID könnte z.B. der Trainingsname sein
        .get();

    if (snapshot.exists) {
      var trainingData = snapshot.data() as Map<String, dynamic>;

      // Setzt die gespeicherten Werte aus Firestore
      training.name = trainingData["name"];
      training.category = trainingData["category"];
      training.exercises = List<Uebung>.from(
        trainingData["exercises"].map((exerciseData) {
          return Uebung.fromMap(exerciseData); // Hier wird fromMap aufgerufen
        }),
      );

      currentExerciseIndex.value = trainingData["currentExerciseIndex"];
      currentSet.value = trainingData["currentSet"];

      // Lade den Fortschritt der Übungen
      for (var exercise in training.exercises) {
        var exerciseData = trainingData["exercises"].firstWhere(
          (ex) => ex["name"] == exercise.name,
        );
        exercise.performedSets =
            List<Map<String, dynamic>>.from(exerciseData["performedSets"]);
      }

      print("Training progress loaded from Firestore!");
    } else {
      print("Kein gespeichertes Training gefunden!");
    }
  }

  Future<void> checkForSavedTraining() async {
    if (userId != null) {
      DocumentSnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('trainings')
          .doc(training.name) // Hier kannst du auch eine andere ID verwenden
          .get();

      if (snapshot.exists) {
        Get.dialog(
          AlertDialog(
            title: Text("Gespeichertes Training gefunden"),
            content: Text("Möchtest du dein Training fortsetzen?"),
            actions: [
              TextButton(
                onPressed: () {
                  loadTrainingProgress(); // Lade das gespeicherte Training
                  Get.back();
                },
                child: Text("Ja"),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("Nein"),
              ),
            ],
          ),
        );
      }
    } else {
      print("Kein Benutzer angemeldet");
    }
  }

  void finishTraining(Training t) {
    saveCompletedTraining(t);
    Get.dialog(
      AlertDialog(
        title: Text("Training abgeschlossen"),
        content: Text("Herzlichen Glückwunsch! Du hast dein Training beendet."),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Schließt den Dialog
              Get.back(); // Geht zum Dashboard zurück
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
