import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/activity_record_model.dart';
import '../../../core/models/user_profile.dart';
import '../../classes/models/character_class.dart';

class LogActivityScreen extends ConsumerStatefulWidget {
  const LogActivityScreen({super.key});

  @override
  ConsumerState<LogActivityScreen> createState() => _LogActivityScreenState();
}

class _LogActivityScreenState extends ConsumerState<LogActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedActivity = 'Cycling';
  int _durationMinutes = 30;

  final Map<String, double> _activityMets = {
    'Cycling': 8.0,
    'Swimming': 7.0,
    'Yoga': 3.0,
    'Weightlifting': 6.0,
    'Running': 9.8,
  };

  void _saveActivity() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final met = _activityMets[_selectedActivity] ?? 5.0;
    
    final userBox = Hive.box<UserProfile>('userProfileBox');
    final profile = userBox.get(0, defaultValue: UserProfile())!;
    final characterClass = CharacterClassModel.getById(profile.currentClassType);

    double multiplier = characterClass.xpMultiplierGeneral;
    if (_selectedActivity == 'Weightlifting') {
      multiplier *= characterClass.xpMultiplierMasmorra;
    } else if (_selectedActivity == 'Running' || _selectedActivity == 'Cycling') {
      multiplier *= characterClass.xpMultiplierHeroesMarch;
    }

    // Calc based on METs, duration, and class multipliers
    final xpEarned = ((met * _durationMinutes) * multiplier).round();

    final newRecord = ActivityRecord(
      id: const Uuid().v4(),
      activityType: _selectedActivity,
      durationMinutes: _durationMinutes,
      metValue: met,
      timestamp: DateTime.now(),
      xpEarned: xpEarned,
    );

    final box = Hive.box<ActivityRecord>('activityRecordsBox');
    await box.add(newRecord);

    
    // Add xp to evolution points
    profile.evolutionPoints += xpEarned;
    // Level up logic placeholder
    if (profile.evolutionPoints >= profile.level * 1000) {
      profile.level++;
      profile.evolutionPoints = 0; // simple reset for now
    }
    await userBox.put(0, profile);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logged $_selectedActivity! Earned $xpEarned XP.')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Alternative Activity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: RPGTheme.inkDark, width: 2),
                  color: RPGTheme.parchmentBackground,
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: _selectedActivity,
                      decoration: const InputDecoration(labelText: 'Activity Type'),
                      items: _activityMets.keys.map((String activity) {
                        return DropdownMenuItem<String>(
                          value: activity,
                          child: Text(activity),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedActivity = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _durationMinutes.toString(),
                      decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Entrar duration';
                        if (int.tryParse(value) == null) return 'Entrar a valid number';
                        return null;
                      },
                      onSaved: (value) {
                        _durationMinutes = int.parse(value!);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveActivity,
                child: const Text('Registrar Atividade & Earn XP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
