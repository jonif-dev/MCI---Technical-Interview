import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mci_fitness_app/model/Training.dart';
import 'package:mci_fitness_app/view/TrainingFlowView.dart';

class TrainingDetailsView extends StatelessWidget {
  final Training currtraining;

  TrainingDetailsView({required this.currtraining});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(currtraining.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currtraining.description,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Kategorie: ${currtraining.category}'),
            Text('Split: ${currtraining.split}'),
            Text('Dauer: ${currtraining.duration} Minuten'),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: currtraining.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = currtraining.exercises[index];
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
            ElevatedButton(
              onPressed: () {
                Get.to(() => TrainingFlowView(training: currtraining));
              },
              child: Text("Training starten"),
            ),
          ],
        ),
      ),
    );
  }
}
