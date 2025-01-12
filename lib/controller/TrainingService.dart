import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mci_fitness_app/model/Training.dart';

class TrainingService {
  static Future<List<Training>> loadTrainings() async {
    final String response =
        await rootBundle.loadString('assets/trainingsplan.json');

    final List<dynamic> data = json.decode(response);

    return data.map((json) => Training.fromJson(json)).toList();
  }
}
