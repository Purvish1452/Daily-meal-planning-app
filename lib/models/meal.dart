class Meal {
  final String? id;
  final String userId;
  final String mealType; // Breakfast, Lunch, Dinner
  final String recipeName;
  final List<String> ingredients;
  final List<String> steps;
  final int? calories;
  final DateTime date;
  final DateTime createdAt;

  Meal({
    this.id,
    required this.userId,
    required this.mealType,
    required this.recipeName,
    required this.ingredients,
    required this.steps,
    this.calories,
    required this.date,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'mealType': mealType,
      'recipeName': recipeName,
      'ingredients': ingredients.join('|'),
      'steps': steps.join('|'),
      'calories': calories,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id']?.toString(),
      userId: json['userId'],
      mealType: json['mealType'],
      recipeName: json['recipeName'],
      ingredients: (json['ingredients'] as String).split('|'),
      steps: (json['steps'] as String).split('|'),
      calories: json['calories'],
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Meal copyWith({
    String? id,
    String? userId,
    String? mealType,
    String? recipeName,
    List<String>? ingredients,
    List<String>? steps,
    int? calories,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return Meal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mealType: mealType ?? this.mealType,
      recipeName: recipeName ?? this.recipeName,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      calories: calories ?? this.calories,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
