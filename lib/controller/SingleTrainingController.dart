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
  Training training; // Aktuelles Training
  Uebung get currentExercise =>
      training.workout.exercises[currentExerciseIndex.value];

  final String? userId = FirebaseAuth.instance.currentUser?.uid; // Benutzer-ID
  var currentExerciseIndex = 0.obs; // Aktuelle Übung
  var currentSet = 1.obs; // Aktueller Satz
  var isBreak = false.obs; // Status der Pause
  var timerDuration = 0.obs; // Dauer der Pause
  var lastE1RM = 0.0.obs; // Letzter berechneter e1RM-Wert

  SingleTrainingController(this.training);

  @override
  void onReady() {
    super.onReady();
    checkForSavedTraining(); // Überprüfen, ob ein gespeichertes Training vorhanden ist
  }

  @override
  void onClose() {
    // Zurücksetzen der Trainingsdaten beim Schließen
    currentSet.value = 1;
    currentExerciseIndex.value = 0;
    isBreak.value = false;
    super.onClose();
  }

  void saveSet(double weight, int reps) {
    // Speichert einen Satz und berechnet den e1RM
    currentExercise.performedSets ??= [];
    currentExercise.performedSets?.add({
      "set": currentSet.value,
      "weight": weight,
      "reps": reps,
    });

    lastE1RM.value = calculateE1RM(weight, reps); // e1RM berechnen

    startBreak(); // Pause starten
  }

  void startBreak() {
    isBreak.value = true;
    timerDuration.value =
        currentExercise.breakTime; // Pause basierend auf Übungszeit

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerDuration.value > 1) {
        timerDuration.value -= 1; // Countdown aktualisieren
      } else {
        timer.cancel(); // Timer stoppen
        isBreak.value = false;

        if (currentSet.value < currentExercise.sets) {
          currentSet.value++; // Nächster Satz
        } else if (currentExerciseIndex.value <
            training.workout.exercises.length - 1) {
          currentExerciseIndex.value++; // Nächste Übung
          currentSet.value = 1;
        } else {
          finishTraining(training); // Training abschließen
        }
      }
    });
  }

  double calculateE1RM(double weight, int reps) {
    // Berechnet den e1RM-Wert basierend auf Gewicht und Wiederholungen
    if (reps == 0) return 0; // Verhindert Division durch 0
    return weight / (0.522 + 0.419 * exp(-0.055 * reps));
  }

  Future<void> saveTraining(Training training, bool done) async {
    // Speichert das aktuelle Training in Firestore
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print('User not logged in'); // Fehlerausgabe bei fehlender Anmeldung
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
      "lastSave": DateTime.now(), // Zeitstempel der Speicherung
      "currentExerciseIndex": currentExerciseIndex.value,
      "currentSet": currentSet.value,
    };

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('trainings')
          .add(doneTraining); // Training hinzufügen
      print('Completed training saved successfully');
    } catch (e) {
      print('Error saving completed training: $e'); // Fehlerausgabe
    }
    Get.find<TrainingsController>()
        .loadTrainings(); // Trainingsliste aktualisieren
  }

  Future<void> loadTrainingProgress(QuerySnapshot snapshot) async {
    // Lädt gespeicherten Trainingsfortschritt
    var trainingData = snapshot.docs.first.data() as Map<String, dynamic>;

    training.workout.name = trainingData['workout']["name"];
    training.workout.category = trainingData['workout']["category"];
    training.workout.exercises = List<Uebung>.from(
      trainingData['workout']["exercises"].map((exerciseData) {
        return Uebung.fromMap(exerciseData); // Erstellt Übung aus Map
      }),
    );

    currentExerciseIndex.value = trainingData["currentExerciseIndex"];
    currentSet.value = trainingData["currentSet"];

    // Fortschritt der Übungen laden
    for (var exercise in training.workout.exercises) {
      var exerciseData = trainingData['workout']["exercises"].firstWhere(
        (ex) => ex["name"] == exercise.name,
      );
      exercise.performedSets =
          List<Map<String, dynamic>>.from(exerciseData["performedSets"]);
    }
  }

  Future<void> checkForSavedTraining() async {
    // Überprüft, ob ein gespeichertes Training vorhanden ist
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
      print(
          "Kein Benutzer angemeldet"); // Fehlerausgabe bei fehlender Anmeldung
    }
  }

  void finishTraining(Training t) {
    // Schließt das Training ab und speichert es
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
