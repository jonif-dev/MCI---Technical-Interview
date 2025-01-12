import 'package:flutter/material.dart';
import 'package:mci_fitness_app/controller/AuthController.dart';
import 'package:mci_fitness_app/controller/TrainingService.dart';
import 'package:mci_fitness_app/model/Training.dart';
import 'package:mci_fitness_app/view/TrainingDetailView.dart';

class DashboardView extends StatelessWidget {
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
      body: FutureBuilder<List<Training>>(
        future: TrainingService.loadTrainings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Fehler beim Laden der Daten.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Keine Trainings gefunden.'));
          }

          final trainings = snapshot.data!;
          return ListView.builder(
            itemCount: trainings.length,
            itemBuilder: (context, index) {
              final training = trainings[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(training.name),
                  subtitle: Text(training.description),
                  trailing: Text('${training.duration} Min'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TrainingDetailsView(currtraining: training),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
