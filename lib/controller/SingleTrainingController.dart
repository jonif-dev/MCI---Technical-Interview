import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mci_fitness_app/controller/TrainingsController.dart';
import 'package:mci_fitness_app/model/Training.dart';
import 'package:mci_fitness_app/model/Uebung.dart';
import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class SingleTrainingController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Training training;
  var currentExerciseIndex = 0.obs;
  var currentSet = 1.obs;
  var isBreak = false.obs;
  var timerDuration = 0.obs;
  var lastE1RM = 0.0.obs;
  Uebung get currentExercise =>
      training.workout.exercises[currentExerciseIndex.value];
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  SingleTrainingController(this.training);

  @override
  void onReady() {
    super.onReady();
    checkForSavedTraining();
  }

  @override
  void onClose() {
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
        } else if (currentExerciseIndex.value <
            training.workout.exercises.length - 1) {
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

  Future<void> saveTraining(Training training, bool done) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print('User not logged in');
      return;
    }

    final doneTraining = {
      "workout": {
        "name": training.workout.name,
        "category": training.workout.category,
        "description": training.workout.description,
        "duration": training.workout.duration,
        "split": training.workout.split,
        "exercises": training.workout.exercises.map((exercise) {
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
            "performedSets": exercise.performedSets ?? [],
          };
        }).toList(),
      },
      "done": done,
      "lastSave": DateTime.now(),
      "currentExerciseIndex": currentExerciseIndex.value,
      "currentSet": currentSet.value,
    };

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('trainings')
          .add(doneTraining);
      print('Completed training saved successfully');
    } catch (e) {
      print('Error saving completed training: $e');
    }
    Get.find<TrainingsController>().loadTrainings();
  }

  // Diese Funktion lädt den gespeicherten Trainingsfortschritt, falls vorhanden
  Future<void> loadTrainingProgress(QuerySnapshot snapshot) async {
    var trainingData = snapshot.docs.first.data() as Map<String, dynamic>;

    // Setzt die gespeicherten Werte aus Firestore
    training.workout.name = trainingData['workout']["name"];
    training.workout.category = trainingData['workout']["category"];
    training.workout.exercises = List<Uebung>.from(
      trainingData['workout']["exercises"].map((exerciseData) {
        return Uebung.fromMap(exerciseData); // Hier wird fromMap aufgerufen
      }),
    );

    currentExerciseIndex.value = trainingData["currentExerciseIndex"];
    currentSet.value = trainingData["currentSet"];

    // Lade den Fortschritt der Übungen
    for (var exercise in training.workout.exercises) {
      var exerciseData = trainingData['workout']["exercises"].firstWhere(
        (ex) => ex["name"] == exercise.name,
      );
      exercise.performedSets =
          List<Map<String, dynamic>>.from(exerciseData["performedSets"]);
    }
  }

  Future<void> checkForSavedTraining() async {
    if (userId != null) {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('trainings')
          .where('workout.name', isEqualTo: training.workout.name)
          .where('done', isEqualTo: false)
          .get();

      if (snapshot.docs.isNotEmpty) {
        Get.dialog(
          AlertDialog(
            title: Text("Gespeichertes Training gefunden"),
            content: Text("Möchtest du dein Training fortsetzen?"),
            actions: [
              TextButton(
                onPressed: () {
                  loadTrainingProgress(
                      snapshot); // Lade das gespeicherte Training
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
    saveTraining(t, true);
    Get.dialog(
      AlertDialog(
        title: Text("Training abgeschlossen"),
        content: Text("Herzlichen Glückwunsch! Du hast dein Training beendet."),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
              Get.back();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
