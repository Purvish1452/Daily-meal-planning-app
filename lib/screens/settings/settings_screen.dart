import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/auth_provider.dart';
import '../../services/storage_service.dart';
import '../../services/notification_service.dart';
import 'package:intl/intl.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TimeOfDay? _breakfastTime;
  TimeOfDay? _lunchTime;
  TimeOfDay? _dinnerTime;
  bool _reminderEnabled = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser == null) return;

    final settings =
        await StorageService.getSettings(authProvider.currentUser!.id);

    if (settings != null) {
      setState(() {
        if (settings['breakfastTime'] != null) {
          _breakfastTime = _parseTime(settings['breakfastTime']);
        }
        if (settings['lunchTime'] != null) {
          _lunchTime = _parseTime(settings['lunchTime']);
        }
        if (settings['dinnerTime'] != null) {
          _dinnerTime = _parseTime(settings['dinnerTime']);
        }
        _reminderEnabled = settings['reminderEnabled'] == 1;
      });
    } else {
      // Default times
      setState(() {
        _breakfastTime = const TimeOfDay(hour: 8, minute: 0);
        _lunchTime = const TimeOfDay(hour: 12, minute: 30);
        _dinnerTime = const TimeOfDay(hour: 19, minute: 0);
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectTime(String mealType) async {
    TimeOfDay? currentTime;
    switch (mealType) {
      case 'breakfast':
        currentTime = _breakfastTime ?? const TimeOfDay(hour: 8, minute: 0);
        break;
      case 'lunch':
        currentTime = _lunchTime ?? const TimeOfDay(hour: 12, minute: 30);
        break;
      case 'dinner':
        currentTime = _dinnerTime ?? const TimeOfDay(hour: 19, minute: 0);
        break;
    }

    final picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );

    if (picked != null) {
      setState(() {
        switch (mealType) {
          case 'breakfast':
            _breakfastTime = picked;
            break;
          case 'lunch':
            _lunchTime = picked;
            break;
          case 'dinner':
            _dinnerTime = picked;
            break;
        }
      });
      await _saveSettings();
    }
  }

  Future<void> _saveSettings() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser == null) return;

    final settings = {
      'breakfastTime': _breakfastTime != null ? _formatTime(_breakfastTime!) : null,
      'lunchTime': _lunchTime != null ? _formatTime(_lunchTime!) : null,
      'dinnerTime': _dinnerTime != null ? _formatTime(_dinnerTime!) : null,
      'reminderEnabled': _reminderEnabled ? 1 : 0,
    };

    await StorageService.saveSettings(authProvider.currentUser!.id, settings);
    await _updateReminders();
  }

  Future<void> _updateReminders() async {
    if (!_reminderEnabled) {
      await NotificationService.cancelAllReminders();
      return;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_breakfastTime != null) {
      final breakfastDateTime = DateTime(
        today.year,
        today.month,
        today.day,
        _breakfastTime!.hour,
        _breakfastTime!.minute,
      );
      if (breakfastDateTime.isAfter(now)) {
        await NotificationService.scheduleMealReminder(
          id: 1,
          title: 'Breakfast Time!',
          body: 'Time for breakfast',
          scheduledDate: breakfastDateTime,
        );
      }
    }

    if (_lunchTime != null) {
      final lunchDateTime = DateTime(
        today.year,
        today.month,
        today.day,
        _lunchTime!.hour,
        _lunchTime!.minute,
      );
      if (lunchDateTime.isAfter(now)) {
        await NotificationService.scheduleMealReminder(
          id: 2,
          title: 'Lunch Time!',
          body: 'Time for lunch',
          scheduledDate: lunchDateTime,
        );
      }
    }

    if (_dinnerTime != null) {
      final dinnerDateTime = DateTime(
        today.year,
        today.month,
        today.day,
        _dinnerTime!.hour,
        _dinnerTime!.minute,
      );
      if (dinnerDateTime.isAfter(now)) {
        await NotificationService.scheduleMealReminder(
          id: 3,
          title: 'Dinner Time!',
          body: 'Time for dinner',
          scheduledDate: dinnerDateTime,
        );
      }
    }
  }

  Future<void> _updateProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser == null) return;

    final usernameController =
        TextEditingController(text: authProvider.currentUser!.username);
    final emailController =
        TextEditingController(text: authProvider.currentUser!.email);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop({
                'username': usernameController.text,
                'email': emailController.text,
              });
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null) {
      await authProvider.updateProfile(result['username']!, result['email']!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: null,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.currentUser;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(user?.username[0].toUpperCase() ?? 'U'),
                  ),
                  title: Text(user?.username ?? 'User'),
                  subtitle: Text(user?.email ?? ''),
                  trailing: const Icon(Icons.edit),
                  onTap: _updateProfile,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Meal Times',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.wb_sunny),
                      title: const Text('Breakfast'),
                      subtitle: Text(
                        _breakfastTime != null
                            ? _breakfastTime!.format(context)
                            : 'Not set',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _selectTime('breakfast'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.lunch_dining),
                      title: const Text('Lunch'),
                      subtitle: Text(
                        _lunchTime != null
                            ? _lunchTime!.format(context)
                            : 'Not set',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _selectTime('lunch'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.dinner_dining),
                      title: const Text('Dinner'),
                      subtitle: Text(
                        _dinnerTime != null
                            ? _dinnerTime!.format(context)
                            : 'Not set',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _selectTime('dinner'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: SwitchListTile(
                  title: const Text('Meal Reminders'),
                  subtitle: const Text('Get notified at meal times'),
                  value: _reminderEnabled,
                  onChanged: (value) async {
                    setState(() {
                      _reminderEnabled = value;
                    });
                    await _saveSettings();
                  },
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: _handleLogout,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
