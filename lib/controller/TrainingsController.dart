import 'package:get/get.dart';
import 'package:mci_fitness_app/controller/AuthController.dart';
import 'package:mci_fitness_app/controller/TrainingService.dart';
import 'package:mci_fitness_app/model/Training.dart';
import 'package:mci_fitness_app/model/Workout.dart';

class TrainingsController extends GetxController {
  var completedTrainings = <Training>[].obs;
  var availableWorkouts = <Workout>[].obs;
  var isLoading = true.obs; // Observable für den Ladezustand

  @override
  void onReady() {
    super.onReady();
    loadTrainings();
  }

  void loadTrainings() async {
    try {
      isLoading.value = true;
      // Lade hier deine Daten (z.B. von Firestore oder einer API)

      final completed = await TrainingService.loadTrainings();
      final available = await TrainingService.loadWorkouts();

      completedTrainings.value = completed;
      availableWorkouts.value = available;
    } finally {
      isLoading.value = false;
    }
  }
}
