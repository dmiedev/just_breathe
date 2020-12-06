import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:just_breathe/src/notifiers/shared_preferences_notifier.dart';

class SettingsDialog extends StatefulWidget {
  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  static const _breathsPerMinuteValues = [4, 5, 6, 7, 8];
  int _breathsPerMinute;

  static const _numberOfCirclesValues = [3, 4, 5];
  int _numberOfCircles;

  @override
  void initState() {
    super.initState();
    final prefs =
        Provider.of<SharedPreferencesNotifier>(context, listen: false);
    _breathsPerMinute = prefs.breathsPerMinute;
    _numberOfCircles = prefs.numberOfCircles;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DropdownButtonFormField(
            value: _breathsPerMinute,
            decoration: InputDecoration(labelText: 'Breath rate'),
            focusColor: Theme.of(context).primaryColor,
            items: [
              for (final value in _breathsPerMinuteValues)
                DropdownMenuItem(
                  child: Text('$value breaths per minute'),
                  value: value,
                ),
            ],
            onChanged: (value) => setState(() => _breathsPerMinute = value),
          ),
          DropdownButtonFormField(
            value: _numberOfCircles,
            decoration: InputDecoration(labelText: 'Number of circles'),
            items: [
              for (final value in _numberOfCirclesValues)
                DropdownMenuItem(
                  child: Text('$value circles'),
                  value: value,
                ),
            ],
            onChanged: (value) => setState(() => _numberOfCircles = value),
          ),
        ],
      ),
      actions: [
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text('APPLY'),
          onPressed: () {
            Provider.of<SharedPreferencesNotifier>(context, listen: false)
              ..breathsPerMinute = _breathsPerMinute
              ..numberOfCircles = _numberOfCircles;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
