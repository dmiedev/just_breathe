import 'dart:math';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import 'package:just_breathe/src/notifiers/shared_preferences_notifier.dart';
import 'package:just_breathe/src/widgets/animated_circle.dart';

class BreathCircleWidget extends StatefulWidget {
  final MaterialColor color;
  final int numberOfCircles;
  final int breathsPerMinute;

  int get breathPeriod => (60 / breathsPerMinute / 2 * 1000).round();

  BreathCircleWidget({this.color, this.numberOfCircles, this.breathsPerMinute});

  @override
  _BreathCircleWidgetState createState() => _BreathCircleWidgetState();
}

class _BreathCircleWidgetState extends State<BreathCircleWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  static const _curve = Curves.easeInOut;
  final _animations = <Animation<double>>[];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.breathPeriod),
    )..forward();
    Wakelock.enable();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animations.first?.removeStatusListener(_animationStatusListener);
    super.dispose();
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _animationController.reverse();
    } else if (status == AnimationStatus.dismissed) {
      _animationController.forward();
    }
  }

  void _updateAnimations(BuildContext context) {
    _animationController.duration = Duration(milliseconds: widget.breathPeriod);
    final media = MediaQuery.of(context);
    final minSize = min(media.size.width, media.size.height);
    final constraints = media.orientation == Orientation.landscape &&
            Provider.of<SharedPreferencesNotifier>(context, listen: false)
                .showAppBar
        ? Scaffold.of(context).appBarMaxHeight
        : 0.0;
    final reduce = constraints + 40.0;
    final maxCircleSize = minSize - reduce;
    final minCircleSize = maxCircleSize / (widget.numberOfCircles * 2 + 1);

    _animations.clear();
    for (int i = 0; i < widget.numberOfCircles; i++) {
      final circleSize = minCircleSize * (i * 2 + 3);
      _animations.add(
        Tween(
          begin: minCircleSize,
          end: circleSize,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: _curve,
            reverseCurve: _curve.flipped,
          ),
        ),
      );
    }
    _animations.first.addStatusListener(_animationStatusListener);
  }

  @override
  Widget build(BuildContext context) {
    _updateAnimations(context);
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        for (int i = widget.numberOfCircles - 1; i >= 0; i--)
          AnimatedCircle(
            animation: _animations[i],
            color: widget.color[500 - 100 * i],
          ),
      ],
    );
  }
}
