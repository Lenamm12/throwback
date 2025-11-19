import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  final SharedPreferences _prefs;

  SettingsService._(this._prefs);

  static Future<SettingsService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsService._(prefs);
  }

  double getFontSize() {
    return _prefs.getDouble('fontSize') ?? 16.0;
  }

  Future<void> setFontSize(double fontSize) async {
    await _prefs.setDouble('fontSize', fontSize);
  }

  String getColorScheme() {
    return _prefs.getString('colorScheme') ?? 'Pink';
  }

  Future<void> setColorScheme(String colorScheme) async {
    await _prefs.setString('colorScheme', colorScheme);
  }

  bool getIsDarkMode() {
    return _prefs.getBool('isDarkMode') ?? false;
  }

  Future<void> setIsDarkMode(bool isDarkMode) async {
    await _prefs.setBool('isDarkMode', isDarkMode);
  }

  String getLanguageCode() {
    return _prefs.getString('languageCode') ?? 'en';
  }

  Future<void> setLanguageCode(String languageCode) async {
    await _prefs.setString('languageCode', languageCode);
  }
}
