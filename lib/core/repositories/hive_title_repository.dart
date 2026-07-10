library hive_title_repository;

import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/title_model.dart';
import 'repository_interfaces.dart';

class HiveTitleRepository implements TitleRepository {
  static const String _boxName = 'titlesBox';
  late Box<TitleModel> _box;

  @override
  Future<void> init() async {
    _box = await Hive.openBox<TitleModel>(_boxName);
    await _initializeDefaults();
  }

  @override
  Future<void> close() async {
    await _box.close();
  }

  Future<void> _initializeDefaults() async {
    if (_box.isEmpty) {
      final defaultTitles = [
        TitleModel(id: 'title_novice', name: 'Novice'),
        TitleModel(id: 'title_walker', name: 'Walker'),
        TitleModel(id: 'title_runner', name: 'Runner'),
        TitleModel(id: 'title_warrior', name: 'Warrior'),
        TitleModel(id: 'title_hero', name: 'Hero'),
        TitleModel(id: 'title_legend', name: 'Legend'),
        TitleModel(id: 'title_champion', name: 'Champion'),
      ];

      for (final title in defaultTitles) {
        await _box.put(title.id, title);
      }
    }
  }

  @override
  Stream<List<TitleModel>> watchAllTitles() {
    return _box.watch().asyncMap((_) async => await getAllTitles());
  }

  @override
  Future<List<TitleModel>> getAllTitles() async {
    return _box.values.toList();
  }

  @override
  Future<TitleModel?> getTitle(String id) async {
    return _box.get(id);
  }

  @override
  Future<void> unlockTitle(String id) async {
    final title = _box.get(id);
    if (title != null && !title.isUnlocked) {
      final updated = title.copyWith(isUnlocked: true);
      await _box.put(id, updated);
    }
  }

  @override
  Future<List<TitleModel>> getUnlockedTitles() async {
    return _box.values.where((title) => title.isUnlocked).toList();
  }
}