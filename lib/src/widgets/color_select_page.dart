import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:just_breathe/src/notifiers/shared_preferences_notifier.dart';

class ColorSelectPage extends StatelessWidget {
  static const routeName = '/color_select';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select color'),
      ),
      body: Consumer<SharedPreferencesNotifier>(
        builder: (_, prefs, __) => GridView.count(
          primary: true,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? 3
                  : 6,
          children: <Widget>[
            for (final color in Colors.primaries)
              _ColorSelectBox(
                isSelected: prefs.primaryColor == color,
                color: color,
                onTap: () => prefs.primaryColor = color,
              )
          ],
        ),
      ),
    );
  }
}

class _ColorSelectBox extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final void Function() onTap;

  _ColorSelectBox({this.color, this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: InkWell(
        onTap: onTap,
        child: isSelected
            ? Icon(
                Icons.check,
                size: 50.0,
                color: ThemeData.estimateBrightnessForColor(color) ==
                        Brightness.dark
                    ? Colors.white
                    : Colors.black,
              )
            : null,
      ),
    );
  }
}
