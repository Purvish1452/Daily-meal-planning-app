import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/meal.dart';
import '../../providers/meal_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/grocery_provider.dart';

class AddEditMealScreen extends StatefulWidget {
  final Meal? meal;
  final String? mealType;

  const AddEditMealScreen({
    super.key,
    this.meal,
    this.mealType,
  });

  @override
  State<AddEditMealScreen> createState() => _AddEditMealScreenState();
}

class _AddEditMealScreenState extends State<AddEditMealScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedMealType;
  late TextEditingController _recipeNameController;
  late TextEditingController _ingredientsController;
  late TextEditingController _stepsController;
  late TextEditingController _caloriesController;
  late DateTime _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedMealType = widget.mealType ?? widget.meal?.mealType ?? 'Breakfast';
    _recipeNameController =
        TextEditingController(text: widget.meal?.recipeName ?? '');
    _ingredientsController = TextEditingController(
        text: widget.meal?.ingredients.join(', ') ?? '');
    _stepsController =
        TextEditingController(text: widget.meal?.steps.join('\n') ?? '');
    _caloriesController = TextEditingController(
        text: widget.meal?.calories?.toString() ?? '');
    _selectedDate = widget.meal?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _recipeNameController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  Future<void> _saveMeal() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final mealProvider = Provider.of<MealProvider>(context, listen: false);
      final groceryProvider =
          Provider.of<GroceryProvider>(context, listen: false);

      final ingredients = _ingredientsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      final steps = _stepsController.text
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final calories = _caloriesController.text.isEmpty
          ? null
          : int.tryParse(_caloriesController.text);

      final meal = Meal(
        id: widget.meal?.id,
        userId: authProvider.currentUser!.id,
        mealType: _selectedMealType,
        recipeName: _recipeNameController.text.trim(),
        ingredients: ingredients,
        steps: steps,
        calories: calories,
        date: _selectedDate,
      );

      bool success;
      if (widget.meal == null) {
        success = await mealProvider.addMeal(meal);
        // Auto-generate grocery list from ingredients
        await groceryProvider.generateFromMeals(ingredients);
      } else {
        success = await mealProvider.updateMeal(meal);
      }

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        if (success) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.meal == null
                  ? 'Meal added successfully!'
                  : 'Meal updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save meal. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meal == null ? 'Add Meal' : 'Edit Meal'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedMealType,
                decoration: const InputDecoration(
                  labelText: 'Meal Type',
                  border: OutlineInputBorder(),
                ),
                items: ['Breakfast', 'Lunch', 'Dinner']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedMealType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(DateFormat('MMM d, y').format(_selectedDate)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _recipeNameController,
                decoration: const InputDecoration(
                  labelText: 'Recipe Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter recipe name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(
                  labelText: 'Ingredients (comma-separated)',
                  border: OutlineInputBorder(),
                  helperText: 'e.g., eggs, milk, flour',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter ingredients';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stepsController,
                decoration: const InputDecoration(
                  labelText: 'Steps (one per line)',
                  border: OutlineInputBorder(),
                  helperText: 'Enter each step on a new line',
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cooking steps';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Calories (optional)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveMeal,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(widget.meal == null ? 'Add Meal' : 'Update Meal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
