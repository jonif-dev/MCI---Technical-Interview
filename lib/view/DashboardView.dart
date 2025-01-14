import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mci_fitness_app/controller/AuthController.dart';
import 'package:intl/intl.dart';
import 'package:mci_fitness_app/controller/TrainingsController.dart';
import 'package:mci_fitness_app/model/Training.dart';

import 'package:mci_fitness_app/view/WorkoutDetailView.dart';
import 'package:mci_fitness_app/view/TrainingFlowView.dart';

class DashboardView extends StatelessWidget {
  final trainingController = Get.put(TrainingsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainings-Dashboard'),
        actions: [
          IconButton(
            onPressed: () => AuthController.instance.logout(),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Obx(
        () {
          // Überprüfe den Ladezustand
          if (trainingController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white, // Farbe passend zu deinem Design
              ),
            );
          }

          // Wenn die Daten geladen sind, zeige die Inhalte an
          final completedTrainings = trainingController.completedTrainings;
          final availableWorkouts = trainingController.availableWorkouts;

          return Column(
            children: [
              // Recent Trainings (Top Section)
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Recent Trainings',
                          style: TextStyle(color: Colors.white70, fontSize: 25),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: completedTrainings.length,
                          itemBuilder: (context, index) {
                            final training = completedTrainings[index];
                            return GestureDetector(
                              onTap: () {
                                if (!training.done) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TrainingFlowView(
                                        training: training,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Card(
                                margin: EdgeInsets.only(right: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: training.done
                                        ? const Color.fromARGB(
                                            255, 105, 105, 105)
                                        : const Color.fromARGB(132, 230, 5,
                                            28), // Farbe basierend auf done-Status
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  width: 150,
                                  height: 100,
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        training.workout.name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        training.done == false
                                            ? 'Übung: ${training.workout.exercises[training.currentExerciseIndex].name} '
                                            : '',
                                        style: TextStyle(
                                          fontSize: 12,

                                          color: training.done == false
                                              ? Colors.black
                                              : Colors
                                                  .transparent, // Textfarbe nur anzeigen, wenn done == false
                                        ),
                                      ),
                                      Text(
                                        training.done == false
                                            ? 'Satz: ${training.currentSet} '
                                            : '',
                                        style: TextStyle(
                                          fontSize: 12,

                                          color: training.done == false
                                              ? Colors.black
                                              : Colors
                                                  .transparent, // Textfarbe nur anzeigen, wenn done == false
                                        ),
                                      ),
                                      Text(
                                        '${training.workout.duration} Min',
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12),
                                      ),
                                      Spacer(),
                                      Text(
                                        DateFormat('HH:mm - dd.MM.yyyy')
                                            .format(training.lastSave!),
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Divider(),
              // Available Workouts (Bottom Section)
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Workouts',
                          style: TextStyle(color: Colors.white70, fontSize: 25),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: availableWorkouts.length,
                          itemBuilder: (context, index) {
                            final workout = availableWorkouts[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WorkoutDetailsView(
                                      currworkout: workout,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        workout.name,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${workout.duration} Min',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
