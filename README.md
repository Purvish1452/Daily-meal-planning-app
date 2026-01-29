# Daily Meal Planning App

A Flutter application for planning daily meals with CRUD functionality, grocery list management, and meal reminders.

## Features

- **User Authentication**: Login and Signup functionality
- **Meal Management**: Add, edit, and delete meals for Breakfast, Lunch, and Dinner
- **Recipe Details**: View recipe name, ingredients, and cooking steps
- **Meal History**: View meals by date with calendar picker
- **Grocery List**: Auto-generated from meal ingredients with manual add/remove and checkbox functionality
- **Search**: Search meals/recipes by name
- **Calorie Tracking**: Optional calorie input with daily total calculation
- **Meal Reminders**: Basic notification reminders for meal times
- **Settings**: Update meal times and user profile

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user.dart
│   ├── meal.dart
│   └── grocery_item.dart
├── providers/                # State management (Provider)
│   ├── auth_provider.dart
│   ├── meal_provider.dart
│   └── grocery_provider.dart
├── services/                 # Services
│   ├── storage_service.dart  # SQLite database operations
│   └── notification_service.dart
├── screens/                  # UI Screens
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── meals/
│   │   ├── add_edit_meal_screen.dart
│   │   └── meal_detail_screen.dart
│   ├── grocery/
│   │   └── grocery_list_screen.dart
│   ├── history/
│   │   └── history_screen.dart
│   ├── search/
│   │   └── search_screen.dart
│   └── settings/
│       └── settings_screen.dart
└── widgets/                  # Reusable widgets
    └── meal_card.dart
```

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android Emulator or Physical Device (for testing)

### Installation

1. **Clone or navigate to the project directory**
   ```bash
   cd "daily meal planning"
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### For Android Notifications

To enable notifications on Android, you may need to add the following to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT"/>
```

## Usage

1. **Sign Up / Login**: Create an account or login with existing credentials
2. **Add Meals**: Tap the "+" button to add meals for Breakfast, Lunch, or Dinner
3. **View Meals**: Tap on any meal card to view full recipe details
4. **Edit/Delete**: Use the menu icon on meal cards to edit or delete
5. **Grocery List**: View auto-generated grocery items or add manually
6. **History**: Browse meals by date using the calendar picker
7. **Search**: Use the search icon to find meals by recipe name
8. **Settings**: Configure meal times and enable/disable reminders

## Technologies Used

- **Flutter**: UI framework
- **Provider**: State management
- **SQLite (sqflite)**: Local database storage
- **SharedPreferences**: User session management
- **flutter_local_notifications**: Meal reminder notifications
- **Material Design 3**: UI components

## Database Schema

- **users**: User accounts
- **meals**: Meal records with recipes
- **grocery_items**: Grocery list items
- **settings**: User preferences (meal times, reminders)

## Notes

- This is a beginner-friendly project suitable for college assignments
- All data is stored locally on the device
- Notifications are simplified for educational purposes
- For production use, consider adding proper timezone handling for notifications

## Future Enhancements

- Cloud sync functionality
- Recipe sharing between users
- Meal photos
- Nutritional information API integration
- Weekly meal planning view
- Export grocery list functionality

## License

This project is created for educational purposes.
