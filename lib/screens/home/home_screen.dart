import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/meal_provider.dart';
import '../../providers/grocery_provider.dart';
import '../meals/add_edit_meal_screen.dart';
import '../meals/meal_detail_screen.dart';
import '../grocery/grocery_list_screen.dart';
import '../history/history_screen.dart';
import '../search/search_screen.dart';
import '../settings/settings_screen.dart';
import '../../widgets/meal_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeProviders();
  }

  Future<void> _initializeProviders() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadUser();

    if (authProvider.currentUser != null) {
      final userId = authProvider.currentUser!.id;
      final mealProvider = Provider.of<MealProvider>(context, listen: false);
      final groceryProvider =
          Provider.of<GroceryProvider>(context, listen: false);

      mealProvider.setUserId(userId);
      groceryProvider.setUserId(userId);

      await mealProvider.loadMeals();
      await mealProvider.loadMealsByDate(DateTime.now());
      await groceryProvider.loadItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Meal Planning'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Grocery',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AddEditMealScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Meal'),
            )
          : null,
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildTodayView();
      case 1:
        return const GroceryListScreen();
      case 2:
        return const HistoryScreen();
      default:
        return _buildTodayView();
    }
  }

  Widget _buildTodayView() {
    return Consumer<MealProvider>(
      builder: (context, mealProvider, _) {
        final today = DateTime.now();
        final todayMeals = mealProvider.todayMeals;
        final totalCalories = mealProvider.getTotalCaloriesForDate(today);

        return RefreshIndicator(
          onRefresh: () async {
            await mealProvider.loadMeals();
            await mealProvider.loadMealsByDate(today);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('EEEE, MMMM d, y').format(today),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total Calories: ${totalCalories > 0 ? totalCalories : "Not set"}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildMealSection('Breakfast', todayMeals, 'Breakfast'),
                const SizedBox(height: 16),
                _buildMealSection('Lunch', todayMeals, 'Lunch'),
                const SizedBox(height: 16),
                _buildMealSection('Dinner', todayMeals, 'Dinner'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMealSection(String title, List meals, String mealType) {
    final mealsOfType = meals.where((m) => m.mealType == mealType).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        if (mealsOfType.isEmpty)
          Card(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddEditMealScreen(mealType: mealType),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline,
                        color: Colors.grey[600]),
                    const SizedBox(width: 16),
                    Text(
                      'Add $title',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...mealsOfType.map((meal) => MealCard(
                meal: meal,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MealDetailScreen(meal: meal),
                    ),
                  );
                },
                onEdit: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddEditMealScreen(meal: meal),
                    ),
                  );
                },
              )),
      ],
    );
  }
}
