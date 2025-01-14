import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mci_fitness_app/controller/SingleTrainingController.dart';
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
    Get.delete<SingleTrainingController>();
    final SingleTrainingController controller =
        Get.put(SingleTrainingController(training));

    final TextEditingController weightController = TextEditingController();
    final TextEditingController repsController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog<bool>(
                context: Get.context!,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Möchtest du wirklich verlassen?'),
                    content: Text(
                        'Du wirst alle nicht gespeicherten Änderungen verlieren.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Get.back(); // Der Benutzer möchte nicht zurückgehen
                        },
                        child: Text('Abbrechen'),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back(); // Der Benutzer möchte zurückgehen
                          Get.back(); // Der Benutzer möchte zurückgehen
                        },
                        child: Text('Ja'),
                      ),
                    ],
                  );
                },
              );
              // Mit GetX zurück navigieren
            },
          ),
          title: Text("Training: ${training.workout.name}")),
      body: Obx(() {
        if (controller.isBreak.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Pause",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white54),
                ),
                SizedBox(height: 16),
                Text(
                  formatDuration(controller.timerDuration.value),
                  style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                SizedBox(height: 50),
                Container(
                  padding: EdgeInsets.all(16),
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        offset: Offset(0, 3), // Schattenposition
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors
                            .black, // Du kannst die Farbe des Icons ändern
                        size: 24,
                      ),
                      SizedBox(width: 35), // Abstand zwischen Icon und Text
                      Expanded(
                        child: Text(
                          "Dein E1RM: ${controller.lastE1RM.value.toStringAsFixed(2)} kg",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .black, // Du kannst die Textfarbe hier ändern
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }

        final currentExercise = controller.currentExercise;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 50,
                  ),
                  Column(
                    children: [
                      Text(
                        "Übung: ${currentExercise.name}",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white54),
                      ),
                      Text(
                        "Satz: ${controller.currentSet} / ${currentExercise.sets}",
                        style: TextStyle(fontSize: 18, color: Colors.white54),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () async {
                      await controller.saveTraining(training, false);
                      Get.back();
                      Get.back();
                      Get.snackbar("Erfolg", "Training wurde gespeichert!");
                    },
                    icon: Icon(
                      Icons.save,
                      size: 30,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                style: TextStyle(color: Colors.white54),
                controller: weightController,
                decoration: InputDecoration(
                  labelText: "Gewicht (${currentExercise.weightUnit})",
                  labelStyle: TextStyle(color: Colors.white), // Label in Weiß
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white, // Weiße Umrandung
                      width: 2.0, // Optional: Dicke der Umrandung
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors
                          .white54, // Weiße Umrandung bei aktiviertem Zustand
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white54, // Weiße Umrandung bei Fokussierung
                      width: 2.0,
                    ),
                  ),
                  hintStyle: TextStyle(
                      color:
                          Colors.white54), // Hint-Text in Weiß mit Transparenz
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                style: TextStyle(color: Colors.white54),
                controller: repsController,
                decoration: InputDecoration(
                  labelText: "Wiederholungen (${currentExercise.repUnit})",
                  labelStyle: TextStyle(color: Colors.white), // Label in Weiß
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white54, // Weiße Umrandung
                      width: 2.0, // Optional: Dicke der Umrandung
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white54, // Weiße Umrandung bei Fokussierung
                      width: 2.0,
                    ),
                  ),
                  hintStyle: TextStyle(
                      color:
                          Colors.white54), // Hint-Text in Weiß mit Transparenz
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 50),
              ElevatedButton.icon(
                onPressed: () {
                  final weight = double.tryParse(weightController.text) ??
                      currentExercise.weight;
                  final reps =
                      int.tryParse(repsController.text) ?? currentExercise.reps;

                  weightController.clear();
                  repsController.clear();

                  controller.saveSet(weight, reps);
                },
                icon: Icon(
                  Icons.pause,
                  size: 30,
                  color: Colors.white54,
                ), // Play-Icon
                label: Text("Satz beenden",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white54)), // Text auf dem Button
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 63, 63, 63), // Button Hintergrundfarbe
                  minimumSize: Size(double.infinity,
                      50), // Breite des Buttons (füllt die Breite des Bildschirms)
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12), // Abgerundete Ecken
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
