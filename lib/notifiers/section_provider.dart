import 'package:flutter/material.dart';
import '../models/section_model.dart';

class SectionProvider extends ChangeNotifier {
  final List<Section> _sections = [
    Section(id: 's1', name: 'Public'),
    Section(id: 's2', name: 'Friends Only', visibleToGroupIds: ['friends']),
  ];

  List<Section> get sections => _sections;

  void addSection(Section section) {
    _sections.add(section);
    notifyListeners();
  }

  void removeSection(Section section) {
    _sections.remove(section);
    notifyListeners();
  }

  void updateSection(Section section) {
    final index = _sections.indexWhere((s) => s.id == section.id);
    if (index != -1) {
      _sections[index] = section;
      notifyListeners();
    }
  }
}
