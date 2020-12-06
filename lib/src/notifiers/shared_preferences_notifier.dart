import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class _SharedPreferencesState {
  int primaryColorIndex;
  int numberOfCircles;
  int breathsPerMinute;
  bool showAppBar;

  _SharedPreferencesState({
    this.primaryColorIndex = defaultPrimaryColorIndex,
    this.numberOfCircles = defaultNumberOfCircles,
    this.breathsPerMinute = defaultBreathsPerMinute,
    this.showAppBar = defaultShowAppBar,
  });

  static const defaultPrimaryColorIndex = 5;
  static const defaultNumberOfCircles = 3;
  static const defaultBreathsPerMinute = 6;
  static const defaultShowAppBar = true;

  static const primaryColorIndexKey = 'primaryColorIndex';
  static const numberOfCirclesKey = 'numberOfCircles';
  static const breathsPerMinuteKey = 'breathsPerMinute';
  static const showAppBarKey = 'showAppBar';
}

class SharedPreferencesNotifier extends ChangeNotifier {
  final _currentPrefs = _SharedPreferencesState();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  int get primaryColorIndex => _currentPrefs.primaryColorIndex;
  MaterialColor get primaryColor => Colors.primaries[primaryColorIndex];
  int get numberOfCircles => _currentPrefs.numberOfCircles;
  int get breathsPerMinute => _currentPrefs.breathsPerMinute;
  bool get showAppBar => _currentPrefs.showAppBar;

  SharedPreferencesNotifier() {
    _loadSharedPreferences();
  }

  Future<void> _loadSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _currentPrefs
      ..primaryColorIndex =
          prefs.get(_SharedPreferencesState.primaryColorIndexKey) ??
              _SharedPreferencesState.defaultPrimaryColorIndex
      ..numberOfCircles =
          prefs.get(_SharedPreferencesState.numberOfCirclesKey) ??
              _SharedPreferencesState.defaultNumberOfCircles
      ..breathsPerMinute =
          prefs.get(_SharedPreferencesState.breathsPerMinuteKey) ??
              _SharedPreferencesState.defaultBreathsPerMinute
      ..showAppBar = prefs.get(_SharedPreferencesState.showAppBarKey) ??
          _SharedPreferencesState.defaultShowAppBar;
    _isLoading = false;
    notifyListeners();
  }

  set primaryColorIndex(int newValue) {
    if (newValue != _currentPrefs.primaryColorIndex) {
      _currentPrefs.primaryColorIndex = newValue;
      _savePreference(_SharedPreferencesState.primaryColorIndexKey, newValue);
      notifyListeners();
    }
  }

  set primaryColor(MaterialColor color) {
    if (color != primaryColor) {
      final index = Colors.primaries.indexOf(color);
      if (index != -1) {
        primaryColorIndex = index;
      }
    }
  }

  set numberOfCircles(int newValue) {
    if (newValue != _currentPrefs.numberOfCircles) {
      _currentPrefs.numberOfCircles = newValue;
      _savePreference(_SharedPreferencesState.numberOfCirclesKey, newValue);
      notifyListeners();
    }
  }

  set breathsPerMinute(int newValue) {
    if (newValue != _currentPrefs.breathsPerMinute) {
      _currentPrefs.breathsPerMinute = newValue;
      _savePreference(_SharedPreferencesState.breathsPerMinuteKey, newValue);
      notifyListeners();
    }
  }

  set showAppBar(bool newValue) {
    if (newValue != _currentPrefs.showAppBar) {
      _currentPrefs.showAppBar = newValue;
      _savePreference(_SharedPreferencesState.showAppBarKey, newValue);
      notifyListeners();
    }
  }

  Future<void> _savePreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    switch (value.runtimeType) {
      case bool:
        await prefs.setBool(key, value);
        break;
      case double:
        await prefs.setDouble(key, value);
        break;
      case int:
        await prefs.setInt(key, value);
        break;
      case String:
        await prefs.setString(key, value);
        break;
      default:
        throw Exception(
          "${value.runtimeType} isn't supported as SharedPreferences value.",
        );
    }
  }
}
