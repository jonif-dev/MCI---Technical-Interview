import 'package:flutter/material.dart';
import 'package:mci_fitness_app/controller/AuthController.dart';
import 'package:mci_fitness_app/controller/TrainingService.dart';
import 'package:mci_fitness_app/model/Training.dart';
import 'package:mci_fitness_app/view/TrainingDetailView.dart';
import 'package:mci_fitness_app/view/TrainingFlowView.dart';

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
      body: FutureBuilder<List<List<Training>>>(
        future: Future.wait([
          TrainingService.loadTrainings(),
          TrainingService.loadWorkouts(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Fehler beim Laden der Daten.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Keine Trainings gefunden.'));
          }

          final completedTrainings = snapshot.data![0];
          final availableTrainings = snapshot.data![1];

          print(completedTrainings);

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
                      Text(
                        'Recent Trainings',
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TrainingFlowView(
                                      training: training,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                margin: EdgeInsets.only(right: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: training.done
                                        ? Colors.white
                                        : Colors.red
                                            .shade100, // Farbe basierend auf done-Status
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      color: training.done
                                          ? Colors.grey.shade300
                                          : Colors.red, // Randfarbe
                                      width: 1.0,
                                    ),
                                  ),
                                  width: 200,
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        training.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Spacer(),
                                      Text(
                                        '${training.duration} Min',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
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
              Divider(),
              // Available Workouts (Bottom Section)
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Workouts',
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
                          itemCount: availableTrainings.length,
                          itemBuilder: (context, index) {
                            final training = availableTrainings[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TrainingDetailsView(
                                      currtraining: training,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        training.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        '${training.duration} Min',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
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
