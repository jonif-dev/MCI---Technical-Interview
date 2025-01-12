import 'package:flutter/material.dart';
import 'package:mci_fitness_app/model/training.dart';

class TrainingDetailsView extends StatelessWidget {
  final Training training;

  TrainingDetailsView({required this.training});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(training.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              training.description,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Kategorie: ${training.category}'),
            Text('Split: ${training.split}'),
            Text('Dauer: ${training.duration} Minuten'),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: training.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = training.exercises[index];
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
          ],
        ),
      ),
    );
  }
}
