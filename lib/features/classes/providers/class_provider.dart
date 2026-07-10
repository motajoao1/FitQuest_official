import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/constants/enums.dart';
import '../models/character_class.dart';
import '../../auth/providers/auth_provider.dart';

class ClassNotifier extends Notifier<CharacterClassModel> {
  @override
  CharacterClassModel build() {
    final box = Hive.box<UserProfile>('userProfileBox');
    final userId = ref.watch(authProvider)?.id ?? '0';
    final profile = box.get(userId) ?? UserProfile();
    return CharacterClassModel.getById(profile.currentClassType);
  }

  void evaluateClass() {
    final box = Hive.box<UserProfile>('userProfileBox');
    final userId = ref.read(authProvider)?.id ?? '0';
    final profile = box.get(userId) ?? UserProfile();

    CharacterClass suggestedClassType = CharacterClass.novice;
    
    // Logic based on current progress
    if (profile.selectedTitleId == 'title_warrior') {
      suggestedClassType = CharacterClass.warrior;
    } else if (profile.stepCount >= 10000 || profile.selectedTitleId == 'title_runner') {
      suggestedClassType = CharacterClass.ranger;
    } else if (profile.level >= 5) {
      suggestedClassType = CharacterClass.warrior; 
    }

    if (profile.currentClassType != suggestedClassType.id) {
      profile.currentClassType = suggestedClassType.id;
      box.put(userId, profile);
      state = CharacterClassModel.getByType(suggestedClassType);
    }
  }

  void setClass(CharacterClass classType) {
    final box = Hive.box<UserProfile>('userProfileBox');
    final userId = ref.read(authProvider)?.id ?? '0';
    final profile = box.get(userId) ?? UserProfile();
    profile.currentClassType = classType.id;
    box.put(userId, profile);
    state = CharacterClassModel.getByType(classType);
  }

  void setClassById(String classId) {
    final classType = CharacterClass.fromId(classId);
    setClass(classType);
  }
}

final classProvider = NotifierProvider<ClassNotifier, CharacterClassModel>(() {
  return ClassNotifier();
});
