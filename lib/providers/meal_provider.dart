import 'package:flutter/foundation.dart';
import '../models/meal.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class MealProvider with ChangeNotifier {
  List<Meal> _meals = [];
  List<Meal> _todayMeals = [];
  String? _currentUserId;
  bool _isLoading = false;

  List<Meal> get meals => _meals;
  List<Meal> get todayMeals => _todayMeals;
  bool get isLoading => _isLoading;

  void setUserId(String userId) {
    _currentUserId = userId;
  }

  Future<void> loadMeals() async {
    if (_currentUserId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _meals = await StorageService.getAllMeals(_currentUserId!);
      _loadTodayMeals();
    } catch (e) {
      debugPrint('Error loading meals: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMealsByDate(DateTime date) async {
    if (_currentUserId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _todayMeals = await StorageService.getMealsByDate(_currentUserId!, date);
    } catch (e) {
      debugPrint('Error loading meals by date: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _loadTodayMeals() {
    final today = DateTime.now();
    _todayMeals = _meals.where((meal) {
      return meal.date.year == today.year &&
          meal.date.month == today.month &&
          meal.date.day == today.day;
    }).toList();
  }

  Future<bool> addMeal(Meal meal) async {
    if (_currentUserId == null) return false;

    try {
      final mealId = await StorageService.insertMeal(meal);
      final newMeal = meal.copyWith(id: mealId.toString());
      _meals.add(newMeal);
      _loadTodayMeals();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error adding meal: $e');
      return false;
    }
  }

  Future<bool> updateMeal(Meal meal) async {
    if (_currentUserId == null || meal.id == null) return false;

    try {
      await StorageService.updateMeal(meal);
      final index = _meals.indexWhere((m) => m.id == meal.id);
      if (index != -1) {
        _meals[index] = meal;
        _loadTodayMeals();
        notifyListeners();
      }
      return true;
    } catch (e) {
      debugPrint('Error updating meal: $e');
      return false;
    }
  }

  Future<bool> deleteMeal(String mealId) async {
    if (_currentUserId == null) return false;

    try {
      await StorageService.deleteMeal(mealId);
      _meals.removeWhere((m) => m.id == mealId);
      _loadTodayMeals();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting meal: $e');
      return false;
    }
  }

  Future<List<Meal>> searchMeals(String query) async {
    if (_currentUserId == null) return [];

    try {
      return await StorageService.searchMeals(_currentUserId!, query);
    } catch (e) {
      debugPrint('Error searching meals: $e');
      return [];
    }
  }

  int getTotalCaloriesForDate(DateTime date) {
    final dateMeals = _meals.where((meal) {
      return meal.date.year == date.year &&
          meal.date.month == date.month &&
          meal.date.day == date.day;
    }).toList();

    return dateMeals
        .where((meal) => meal.calories != null)
        .fold(0, (sum, meal) => sum + (meal.calories ?? 0));
  }

  List<Meal> getMealsByDate(DateTime date) {
    return _meals.where((meal) {
      return meal.date.year == date.year &&
          meal.date.month == date.month &&
          meal.date.day == date.day;
    }).toList();
  }
}
