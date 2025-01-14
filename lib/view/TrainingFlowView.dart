import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mci_fitness_app/controller/SingleTrainingController.dart';
import 'package:mci_fitness_app/model/Training.dart';

//TrainingsFlow ist die Ansichtt die angezeigt  wird wenn ein  Training gestartet wird
//Dabei wird zwischen Übung und Pause gewechselt bis das Training abgeschlossen ist
class TrainingFlowView extends StatelessWidget {
  final Training training;

  TrainingFlowView({required this.training});

  //Formatiert die Timer auf mm:ss
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
              //Bestätigungsfeld, das angezeigt wird, wenn man das Training ohne Speichern verlassen möchte
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
                          Get.back();
                        },
                        child: Text('Abbrechen'),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                          Get.back();
                        },
                        child: Text('Ja'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          title: Text("Training: ${training.workout.name}")),
      body: Obx(() {
        //Ansicht der Pause mit Timer und Infofeld für E1RM
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
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.black,
                        size: 24,
                      ),
                      SizedBox(width: 35),
                      Expanded(
                        child: Text(
                          "Dein E1RM: ${controller.lastE1RM.value.toStringAsFixed(2)} kg",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
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
        //Ansicht einer Übung mit Eingabefelder für Gewicht und Wiederholungen, zudem einem Button zum Speichern und Pausieren
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
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white54,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white54,
                      width: 2.0,
                    ),
                  ),
                  hintStyle: TextStyle(color: Colors.white54),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                style: TextStyle(color: Colors.white54),
                controller: repsController,
                decoration: InputDecoration(
                  labelText: "Wiederholungen (${currentExercise.repUnit})",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white54,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white54,
                      width: 2.0,
                    ),
                  ),
                  hintStyle: TextStyle(color: Colors.white54),
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
                ),
                label: Text("Satz beenden",
                    style: TextStyle(fontSize: 16, color: Colors.white54)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 63, 63, 63),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
