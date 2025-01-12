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
  List<Map<String, dynamic>>?
      performedSets; // Liste für Sätze während des Trainings

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
    this.performedSets,
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
      performedSets: [],
    );
  }

  // fromMap Methode
  factory Uebung.fromMap(Map<String, dynamic> map) {
    return Uebung(
      name: map['name'],
      sets: map['sets'],
      reps: map['reps'],
      repUnit: map['repUnit'],
      weight: map['weight'],
      weightUnit: map['weightUnit'],
      breakTime: map['break'],
      muscleGroup: map['muscleGroup'],
      equipment: List<String>.from(map['equipment']),
      performedSets: map['performedSets'] != null
          ? List<Map<String, dynamic>>.from(map['performedSets'])
          : [],
    );
  }
}
