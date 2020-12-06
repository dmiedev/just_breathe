import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:just_breathe/src/notifiers/shared_preferences_notifier.dart';
import 'package:just_breathe/src/app.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SharedPreferencesNotifier(),
      child: StopJustBreatheApp(),
    ),
  );
}
