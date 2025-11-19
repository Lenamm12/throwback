import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class LocaleNotifier with ChangeNotifier {
  final SettingsService _settingsService;
  late Locale _locale;

  LocaleNotifier(this._settingsService) {
    _locale = Locale(_settingsService.getLanguageCode());
  }

  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    _locale = newLocale;
    _settingsService.setLanguageCode(newLocale.languageCode);
    notifyListeners();
  }
}
