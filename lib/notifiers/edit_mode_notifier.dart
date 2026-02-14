import 'package:flutter/material.dart';

class EditModeNotifier extends ChangeNotifier {
  bool _isEditMode = false;

  bool get isEditMode => _isEditMode;

  void toggleEditMode() {
    _isEditMode = !_isEditMode;
    notifyListeners();
  }
}