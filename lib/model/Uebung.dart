// Die Klasse Uebung repräsentiert eine Übung in einem Trainingsplan
class Uebung {
  final String name; // Der Name der Übung
  final int sets; // Anzahl der Sätze
  final int reps; // Anzahl der Wiederholungen pro Satz
  final String
      repUnit; // Einheit der Wiederholungen (z.B. "Wiederholungen" oder "Sekunden")
  final double weight; // Das verwendete Gewicht (z.B. in Kilogramm)
  final String weightUnit; // Einheit des Gewichts (z.B. "kg")
  final int breakTime; // Die Pause zwischen den Sätzen (in Sekunden)
  final String
      muscleGroup; // Die Hauptmuskelgruppe, die bei dieser Übung trainiert wird (z.B. "Beine")
  final List<String>
      equipment; // Liste der benötigten Ausrüstung (z.B. "Kurzhanteln", "Bank")

  // Liste für die Sätze, die während des Trainings ausgeführt wurden (enthält detaillierte Informationen)
  List<Map<String, dynamic>>? performedSets;

  // Konstruktor der Klasse Uebung, der alle Eigenschaften initialisiert
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
    this.performedSets, // Optional: Liste der ausgeführten Sätze
  });

  // Factory-Methode zum Erstellen eines Uebung-Objekts aus einer JSON-Struktur
  factory Uebung.fromJson(Map<String, dynamic> json) {
    return Uebung(
      name: json['name'],
      sets: json['sets'],
      reps: json['reps'],
      repUnit: json['repUnit'],
      weight:
          (json['weight'] as num).toDouble(), // Umwandlung von num auf double
      weightUnit: json['weightUnit'],
      breakTime: json['break'], // Wurde als 'break' im JSON übergeben
      muscleGroup: json['muscleGroup'],
      equipment: List<String>.from(
          json['equipment']), // Konvertierung von List<dynamic> in List<String>
      performedSets: [], // Initialisierung der Liste performedSets als leer
    );
  }

  // Factory-Methode zum Erstellen eines Uebung-Objekts aus einer Map
  factory Uebung.fromMap(Map<String, dynamic> map) {
    return Uebung(
      name: map['name'],
      sets: map['sets'],
      reps: map['reps'],
      repUnit: map['repUnit'],
      weight: map['weight'], // Gewicht direkt aus der Map übernehmen
      weightUnit: map['weightUnit'],
      breakTime: map['break'], // Pausenzeit aus der Map übernehmen
      muscleGroup: map['muscleGroup'],
      equipment:
          List<String>.from(map['equipment']), // Ausrüstungsliste konvertieren
      performedSets: map['performedSets'] != null
          ? List<Map<String, dynamic>>.from(map[
              'performedSets']) // Wenn performedSets nicht null ist, als Liste von Maps konvertieren
          : [], // Falls performedSets null ist, eine leere Liste verwenden
    );
  }
}
