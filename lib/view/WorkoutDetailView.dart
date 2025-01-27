import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mci_fitness_app/model/Training.dart';
import 'package:mci_fitness_app/model/Workout.dart';
import 'package:mci_fitness_app/view/TrainingFlowView.dart';

//WorkoutDetail zeigt eine Workout im detail an, dabei ist eine Beschreibung zu sehen sowie  alle Übungen mit  Gewichtszahl, Wiederholungen und Sets
class WorkoutDetailsView extends StatelessWidget {
  final Workout currworkout;

  WorkoutDetailsView({required this.currworkout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(currworkout.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currworkout.description,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white60),
            ),
            SizedBox(height: 16),
            Text('Kategorie: ${currworkout.category}',
                style: TextStyle(color: Colors.white60)),
            Text('Split: ${currworkout.split}',
                style: TextStyle(color: Colors.white60)),
            Text('Dauer: ${currworkout.duration} Minuten',
                style: TextStyle(color: Colors.white60)),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: currworkout.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = currworkout.exercises[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(exercise.name),
                      subtitle: Text(
                          '${exercise.sets} Sätze x ${exercise.reps} ${exercise.repUnit} (${exercise.weight} ${exercise.weightUnit})'),
                      trailing: Text('${exercise.breakTime}s Pause'),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Get.to(() => TrainingFlowView(
                    training: new Training(workout: currworkout)));
              },
              icon: Icon(
                Icons.play_arrow,
                size: 30,
                color: Colors.white54,
              ),
              label: Text("Training starten",
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
      ),
    );
  }
}
