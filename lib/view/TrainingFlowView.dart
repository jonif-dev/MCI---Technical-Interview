import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mci_fitness_app/controller/TrainingController.dart';
import 'package:mci_fitness_app/model/Training.dart';

class TrainingFlowView extends StatelessWidget {
  final Training training;

  TrainingFlowView({required this.training});

  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final TrainingController controller = Get.put(TrainingController(training));

    final TextEditingController weightController = TextEditingController();
    final TextEditingController repsController = TextEditingController();
    Get.delete<TrainingController>();
    return Scaffold(
      appBar: AppBar(title: Text("Training: ${training.name}")),
      body: Obx(() {
        if (controller.isBreak.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Pause",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  formatDuration(controller.timerDuration.value),
                  style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                SizedBox(height: 16),
                Text(
                  "Dein geschätztes 1RM: ${controller.lastE1RM.value.toStringAsFixed(2)} kg",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text("Nächster Satz startet in wenigen Momenten."),
              ],
            ),
          );
        }

        final currentExercise = controller.currentExercise;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Übung: ${currentExercise.name}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                  "Satz: ${controller.currentSet} von ${currentExercise.sets}"),
              SizedBox(height: 16),
              TextField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText: "Gewicht (${currentExercise.weightUnit})",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: repsController,
                decoration: InputDecoration(
                  labelText: "Wiederholungen (${currentExercise.repUnit})",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final weight = double.tryParse(weightController.text) ??
                      currentExercise.weight;
                  final reps =
                      int.tryParse(repsController.text) ?? currentExercise.reps;

                  weightController.clear();
                  repsController.clear();

                  controller.saveSet(weight, reps);
                },
                child: Text("Satz speichern und Pause starten"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await controller.saveTrainingProgress();
                  Get.snackbar("Erfolg", "Training wurde gespeichert!");
                },
                child: Text("Training für später speichern"),
              ),
            ],
          ),
        );
      }),
    );
  }
}
