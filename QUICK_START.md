# Quick Start Guide

## First Time Setup

1. **Install Flutter** (if not already installed)
   - Visit https://flutter.dev/docs/get-started/install
   - Follow platform-specific instructions

2. **Verify Installation**
   ```bash
   flutter doctor
   ```

3. **Get Dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the App**
   ```bash
   flutter run
   ```

## Testing the App

### 1. Create an Account
- Launch the app
- Tap "Don't have an account? Sign Up"
- Enter:
  - Username: `testuser`
  - Email: `test@example.com`
  - Password: `test1234`
  - Confirm Password: `test1234`
- Tap "Sign Up"

### 2. Add Your First Meal
- Tap the "+ Add Meal" button
- Select meal type: Breakfast
- Enter recipe name: `Scrambled Eggs`
- Enter ingredients: `eggs, butter, salt, pepper`
- Enter steps:
  ```
  Crack eggs into a bowl
  Add salt and pepper
  Heat butter in pan
  Scramble eggs until cooked
  ```
- Enter calories: `250` (optional)
- Tap "Add Meal"

### 3. View Grocery List
- Navigate to "Grocery" tab
- You should see ingredients from your meal auto-generated
- Tap checkbox to mark items as purchased
- Tap "+" to add manual items

### 4. View Meal History
- Navigate to "History" tab
- Tap the date card to select a different date
- View meals for that date

### 5. Search Meals
- Tap the search icon in the app bar
- Type recipe name to search

### 6. Configure Settings
- Tap the settings icon
- Set meal times for reminders
- Toggle meal reminders on/off
- Update profile information

## Sample Data

Try adding these meals to test the app:

**Breakfast:**
- Recipe: Oatmeal
- Ingredients: oats, milk, honey, banana
- Calories: 300

**Lunch:**
- Recipe: Chicken Salad
- Ingredients: chicken, lettuce, tomato, cucumber, olive oil
- Calories: 450

**Dinner:**
- Recipe: Pasta Carbonara
- Ingredients: pasta, eggs, bacon, parmesan, black pepper
- Calories: 600

## Troubleshooting

### App won't start
- Run `flutter clean`
- Run `flutter pub get`
- Run `flutter run`

### Database errors
- Uninstall the app from your device/emulator
- Reinstall and try again

### Notifications not working
- Check app permissions in device settings
- For Android, ensure notification permissions are granted

## Features Checklist

- ✅ User login/signup
- ✅ Add meals (Breakfast, Lunch, Dinner)
- ✅ Edit meals
- ✅ Delete meals
- ✅ View recipe details
- ✅ Meal history by date
- ✅ Auto-generated grocery list
- ✅ Manual grocery items
- ✅ Checkbox for grocery items
- ✅ Search meals
- ✅ Calorie tracking
- ✅ Daily calorie total
- ✅ Meal reminders
- ✅ Settings (meal times, profile)
