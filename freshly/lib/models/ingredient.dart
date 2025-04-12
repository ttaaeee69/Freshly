class Ingredient {
  final String name;
  final DateTime startDate;

  Ingredient({required this.name, required this.startDate});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "startDate": startDate.toIso8601String(),
    };
  }

  @override
  String toString() => "Ingredient(name: $name, startDate: $startDate)";
}
