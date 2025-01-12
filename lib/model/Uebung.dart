class Uebung {
  final String name;
  final int sets;
  final int reps;
  final String repUnit;
  final double weight;
  final String weightUnit;
  final int breakTime;
  final String muscleGroup;
  final List<String> equipment;

  Uebung({
    required this.name,
    required this.sets,
    required this.reps,
    required this.repUnit,
    required this.weight,
    required this.weightUnit,
    required this.breakTime,
    required this.muscleGroup,
    required this.equipment,
  });

  factory Uebung.fromJson(Map<String, dynamic> json) {
    return Uebung(
      name: json['name'],
      sets: json['sets'],
      reps: json['reps'],
      repUnit: json['repUnit'],
      weight: (json['weight'] as num).toDouble(),
      weightUnit: json['weightUnit'],
      breakTime: json['break'],
      muscleGroup: json['muscleGroup'],
      equipment: List<String>.from(json['equipment']),
    );
  }
}
