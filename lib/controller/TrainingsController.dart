import 'package:get/get.dart';
import 'package:mci_fitness_app/controller/TrainingService.dart';
import 'package:mci_fitness_app/model/Training.dart';
import 'package:mci_fitness_app/model/Workout.dart';

class TrainingsController extends GetxController {
  var completedTrainings = <Training>[].obs; // Abgeschlossene Trainings
  var availableWorkouts = <Workout>[].obs; // Verfügbare Workouts
  var isLoading = true.obs; // Ladezustand der Daten

  @override
  void onReady() {
    super.onReady();
    loadTrainings(); // Trainingsdaten laden, sobald Controller bereit ist
  }

  void loadTrainings() async {
    try {
      isLoading.value = true; // Setze Ladezustand auf "true"

      // Lade abgeschlossene Trainings und verfügbare Workouts aus dem Service
      final completed = await TrainingService.loadTrainings();
      final available = await TrainingService.loadWorkouts();

      // Aktualisiere die Listen mit den geladenen Daten
      completedTrainings.value = completed;
      availableWorkouts.value = available;
    } finally {
      isLoading.value = false; // Ladezustand auf "false" setzen, wenn fertig
    }
  }
}
