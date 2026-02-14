import 'package:flutter/material.dart';
import 'package:myapp/models/group_model.dart';

class GroupProvider extends ChangeNotifier {
  List<Group> _groups = [];

  List<Group> get groups => _groups;

  void addGroup(Group group) {
    _groups.add(group);
    notifyListeners();
  }

  void removeGroup(Group group) {
    _groups.remove(group);
    notifyListeners();
  }

  void updateGroup(Group group) {
    int index = _groups.indexWhere((g) => g.id == group.id);
    _groups[index] = group;
    notifyListeners();
  }
}