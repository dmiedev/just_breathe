import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:just_breathe/src/widgets/home_page.dart';
import 'package:just_breathe/src/notifiers/shared_preferences_notifier.dart';
import 'package:just_breathe/src/widgets/color_select_page.dart';

class StopJustBreatheApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SharedPreferencesNotifier>(
      builder: (_, prefs, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Stop! Just Breathe',
          theme: ThemeData(
            primarySwatch: prefs.primaryColor,
            scaffoldBackgroundColor: prefs.primaryColor[50],
            fontFamily: 'Montserrat',
          ),
          home: HomePage(),
          routes: {
            ColorSelectPage.routeName: (context) => ColorSelectPage(),
          },
        );
      },
    );
  }
}
