import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:just_breathe/src/notifiers/shared_preferences_notifier.dart';
import 'package:just_breathe/src/widgets/color_select_page.dart';
import 'package:just_breathe/src/widgets/settings_dialog.dart';
import 'package:just_breathe/src/widgets/breath_circle.dart';

enum _PopupMenuItem {
  colorSelect,
  settings,
  about,
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SharedPreferencesNotifier>(
      builder: (_, prefs, __) => Scaffold(
        appBar: prefs.showAppBar
            ? AppBar(
                leading: IconButton(
                  icon: Icon(Icons.keyboard_arrow_up),
                  onPressed: () => _onSwitchShowAppBarButtonPressed(context),
                ),
                title: Text('Stop! Just Breathe'),
                actions: <Widget>[
                  PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    onSelected: (item) =>
                        _onPopupMenuItemSelected(item, context),
                    itemBuilder: (context) {
                      return <PopupMenuEntry>[
                        PopupMenuItem(
                          child: Text('Select color'),
                          value: _PopupMenuItem.colorSelect,
                        ),
                        PopupMenuItem(
                          child: Text('Settings'),
                          value: _PopupMenuItem.settings,
                        ),
                        PopupMenuItem(
                          child: Text('About'),
                          value: _PopupMenuItem.about,
                        ),
                      ];
                    },
                  ),
                ],
              )
            : null,
        body: SafeArea(
          child: Stack(
            children: [
              if (!prefs.showAppBar)
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 5.0, top: 5.0),
                  child: IconButton(
                    icon: Icon(Icons.keyboard_arrow_down),
                    onPressed: () => _onSwitchShowAppBarButtonPressed(context),
                  ),
                ),
              Center(
                child: Consumer<SharedPreferencesNotifier>(
                  builder: (_, prefs, __) => BreathCircleWidget(
                    color: prefs.primaryColor,
                    numberOfCircles: prefs.numberOfCircles,
                    breathsPerMinute: prefs.breathsPerMinute,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSwitchShowAppBarButtonPressed(BuildContext context) {
    final prefs =
        Provider.of<SharedPreferencesNotifier>(context, listen: false);
    prefs.showAppBar = !prefs.showAppBar;
    SystemChrome.setEnabledSystemUIOverlays([
      if (prefs.showAppBar) SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ]);
  }

  void _onPopupMenuItemSelected(_PopupMenuItem item, BuildContext context) {
    switch (item) {
      case _PopupMenuItem.colorSelect:
        Navigator.pushNamed(
          context,
          ColorSelectPage.routeName,
        );
        break;
      case _PopupMenuItem.settings:
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => SettingsDialog(),
        );
        break;
      case _PopupMenuItem.about:
        showAboutDialog(
          context: context,
          applicationVersion: '2.0.0',
          applicationLegalese: '2019 - 2020 © Dmitry Egorov',
        );
        break;
    }
  }
}
